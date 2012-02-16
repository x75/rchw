/* 
 * FrameModder, to be run within the rapidsmith framework
 *
 * read bitstream, change some of the BRAM configuration
 * write back out
 * heavily inspired by the bitstreamTools.examples
 */

package edu.byu.ece.rapidSmith.bitstreamTools.dprtests;

import java.util.Iterator;
import java.util.List;
import java.util.ArrayList;

import joptsimple.OptionSet;
import edu.byu.ece.rapidSmith.bitstreamTools.configuration.FPGA;
import edu.byu.ece.rapidSmith.bitstreamTools.configuration.Frame;
import edu.byu.ece.rapidSmith.bitstreamTools.configuration.FrameAddressRegister;
import edu.byu.ece.rapidSmith.bitstreamTools.configuration.FrameData;
import edu.byu.ece.rapidSmith.bitstreamTools.bitstream.Bitstream;
import edu.byu.ece.rapidSmith.bitstreamTools.bitstream.BitstreamHeader;
import edu.byu.ece.rapidSmith.bitstreamTools.configuration.BitstreamGenerator;
import edu.byu.ece.rapidSmith.bitstreamTools.configurationSpecification.XilinxConfigurationSpecification;
import edu.byu.ece.rapidSmith.bitstreamTools.configurationSpecification.AbstractConfigurationSpecification;
import edu.byu.ece.rapidSmith.bitstreamTools.examples.support.BitstreamOptionParser;

/**
 * This method is used to load a bitstream, change the config and write it out again
 *
 */
public class FrameModder {
		public static void main(String[] args) {
				/** Setup option parser **/
				BitstreamOptionParser cmdLineParser = new BitstreamOptionParser();
				cmdLineParser.addInputBitstreamOption();
				cmdLineParser.addHelpOption();
				// cmdLineParser.addPartNameOption();
				// cmdLineParser.addRawReadbackInputOption();

				OptionSet options = null;
				try {
						options = cmdLineParser.parse(args);
				}
				catch(Exception e){
						System.err.println(e.getMessage());
						System.exit(1);			
				}		

				BitstreamOptionParser.printExecutableHeaderMessage(FrameModder.class);

				/////////////////////////////////////////////////////////////////////
				// Begin basic command line parsing
				/////////////////////////////////////////////////////////////////////
				cmdLineParser.checkHelpOptionExitOnHelpMessage(options);

				/////////////////////////////////////////////////////////////////////
				// 1. Parse bitstream
				/////////////////////////////////////////////////////////////////////
				FPGA fpga = null;
		
				fpga = cmdLineParser.createFPGAFromBitstreamOrReadbackFileExitOnError(options);

				XilinxConfigurationSpecification partInfo = fpga.getDeviceSpecification();

				ArrayList<Frame> fpgaConfiguredFrames = fpga.getConfiguredFrames();
				System.out.println("Number of configured Frames:" + fpgaConfiguredFrames.size());

				int firstConfiguredFrame = fpgaConfiguredFrames.get(0).getFrameAddress();
				FrameAddressRegister far = new FrameAddressRegister(partInfo, firstConfiguredFrame);
				FrameAddressRegister far_bramstart = new FrameAddressRegister(partInfo, 3146240);
				System.out.println("first configured frame FAR: " + firstConfiguredFrame + "\n" + far);

				// save bitstream copy before modifications
				

				// grab a frame, change it, and write it back
				fpga.setFAR(3146240);
				for(int i = 0; i < 8; i++) {
						Frame fr = fpga.getFrame(fpga.getFAR());
						System.out.println(fpga.getFrameData());
						System.out.println(fr);
						FrameData frda = fr.getData();
						frda.zeroData();
						//frda.setData(15, 65536);
						if(i % 2 == 0)
								frda.setData(10, 1);
						else
								frda.setData(11, 1);
						fr.configure(frda);
						System.out.println(fr);
						fpga.incrementFAR();
				}
				// here we're done because configuration is immediatly written
				// back to the FPGA
				//fpga.configureWithData(frda.getAllFrameWords());

				// iterate over all frames
				if(false) {
						int cfar;
						String blockTypeString;
						FrameData fData = null;
						List<Integer> fDataInts;
						for (Frame fd : fpgaConfiguredFrames) {
								System.out.println(">===========================================================");
								// fd.clear();
								// 
								cfar = fd.getFrameAddress();
								far.setFAR(cfar);

								System.out.println("FAR Address: " + cfar);
								System.out.println(fd + "\nfd.class: " + fd.getClass() + "\nfar: " + far);

								fData = fd.getData();
								System.out.println("Frame data size: " + fData.size());
								System.out.println("Frame data:\n" + fData);
								fDataInts = fData.getAllFrameWords();
								System.out.println(fDataInts);

								blockTypeString = AbstractConfigurationSpecification.getBlockType(partInfo, far.getBlockType());
								System.out.println(blockTypeString);
								if(far.getAddress() == far_bramstart.getAddress()) {
										System.out.println("found BRAM Block start");
										// set data attempt #1
										fData.zeroData();
										fDataInts = fData.getAllFrameWords();
										fDataInts.set(15, 65536);
										System.out.println(fDataInts);

										// set data attempt #2
										fData.setData(15, 65536);

										// FrameData fDataNew = new FrameData(fDataInts.toArray());
										System.out.println("Frame data new:\n" + fData);
								}
								if(blockTypeString.equals("BRAM")) {
										System.out.println("found BRAM Frame");
								}
								System.out.println("<===========================================================");
						}
				}

				// for(int i = 0; i < fpgaConfiguredFrames.size(); i++) {
				// 		System.out.println("Frame " + i + ": " + fpgaConfiguredFrames[i]);
				// }

				// Iterator confFramesIter = fpgaConfiguredFrames.iterator();
				// Frame cframe = null;
				// while(confFramesIter.hasNext()) {
				// 		// cframe = confFramesIter.next();
				// 		System.out.println(confFramesIter.next().getClass());
				// 		// System.out.println("current Frame: FAR: " + cframe.getFrameAddress() + ", content: ");
				// 		// System.out.println(cframe);
				// }

				// System.out.println(fpga.configData.length);
				System.out.println(fpga.getFAR());

				// 2. start work
				int startFrame = 0;
				int defaultNumberOfFrames = FrameAddressRegister.getNumberOfFrames(partInfo);

				// System.out.println(partInfo);
				// System.out.println(fpga.getFrameContents(startFrame, defaultNumberOfFrames));


				// write bitstream
				// create header
				//System.out.println(bsh);
				//System.out.println(fpga.getDeviceSpecification()); == partInfo
				//BitstreamHeader bsh = new BitstreamHeader("blub.ncd", partInfo.getDeviceName());
				BitstreamHeader bsh = new BitstreamHeader("config_4_routed.ncd", "5vsx50tff1136");
				System.out.println(bsh);
				BitstreamGenerator bsg = partInfo.getBitstreamGenerator();
				System.out.println(bsg);
				Bitstream bs = bsg.createPartialBitstream(fpga, bsh);
				//System.out.println(bs);
				bsg.writeBitstreamToBIT(bs, "blub.bit");
				// create fpga: already exists
				// create BitstreamGenerator
		}
}