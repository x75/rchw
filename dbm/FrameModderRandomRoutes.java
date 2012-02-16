/* 
 * FrameModderRandomRoutes, to be run within the rapidsmith framework
 *
 * read bitstream, randomly change some CFs
 * write back out
 * heavily inspired by the bitstreamTools.examples
 *
 * analyze with debit (use as FPGA simulator)
 *
 * designed for operation on fourlut standalone design, targetted
 * at 5vlx50-1-ff676, because of better debit support
 */

// compile out of tree
// package edu.byu.ece.rapidSmith.bitstreamTools.dprtests;

import java.util.Iterator;
import java.util.List;
import java.util.ArrayList;
import java.util.Random;

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
public class FrameModderRandomRoutes {

		public static final String STARTFRAME_OPTION_STRING = "s";
		public static final String SELCTFRAME_OPTION_STRING = "e";

		public static void main(String[] args) {
				/** Setup option parser **/
				BitstreamOptionParser cmdLineParser = new BitstreamOptionParser();
				cmdLineParser.addInputBitstreamOption();
				cmdLineParser.addHelpOption();
				// cmdLineParser.addPartNameOption();
				// cmdLineParser.addRawReadbackInputOption();
				cmdLineParser.accepts(STARTFRAME_OPTION_STRING, "Specify start frame for LUT configuration area").withRequiredArg().ofType(Integer.class);
				cmdLineParser.accepts(SELCTFRAME_OPTION_STRING, "Specify selct frame for LUT configuration area").withRequiredArg().ofType(Integer.class);;

				OptionSet options = null;
				try {
						options = cmdLineParser.parse(args);
				}
				catch(Exception e){
						System.err.println(e.getMessage());
						System.exit(1);			
				}		

				BitstreamOptionParser.printExecutableHeaderMessage(FrameModderRandomRoutes.class);

				/////////////////////////////////////////////////////////////////////
				// Begin basic command line parsing
				/////////////////////////////////////////////////////////////////////
				cmdLineParser.checkHelpOptionExitOnHelpMessage(options);

				boolean haveStartframe =
						options.has(STARTFRAME_OPTION_STRING);
				boolean haveSelctframe =
						options.has(SELCTFRAME_OPTION_STRING);

				// option -s / startframe
				Integer startframe_lutconf = 0x0001131A;
				int startframe_lutconf_num;

				if(haveStartframe) {
						//System.out.println("Startframe for LUT config: pre get arg");
						startframe_lutconf = (Integer)options.valueOf(STARTFRAME_OPTION_STRING);
						//System.out.println("Startframe for LUT config: post get arg: " + startframe_lutconf);
				}
				// startframe_lutconf_num = Integer.parseInt(startframe_lutconf, 16);
				startframe_lutconf_num = startframe_lutconf.intValue();
				System.out.println("Startframe for LUT config: " + startframe_lutconf + ", " + startframe_lutconf_num);

				// option -e / select frame
				Integer selctframe = 0x0;
				int selctframe_num;

				if(haveSelctframe) {
						//System.out.println("Selctframe for LUT config: pre get arg");
						selctframe = (Integer)options.valueOf(SELCTFRAME_OPTION_STRING);
						//System.out.println("Selctframe for LUT config: post get arg: " + selctframe_lutconf);
				}
				// selctframe_lutconf_num = Integer.parseInt(selctframe_lutconf, 16);
				selctframe_num = selctframe.intValue();
				System.out.println("Selctframe for LUT config: " + selctframe + ", " + selctframe_num);

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

				// init RNG
				Random rand = new Random();
				System.out.println(rand.nextInt(10));

				// save bitstream copy before modifications
				
				// grab a frame, change it, and write it back
				// first configured frame: 1114240
				// new FAR: 00110080: 1114246
				// 1114240
				// 1: 18, 22, 23, 24, 25, 
				// 2: 10, 13, 20, 21, 22,
				// -1: 0,1,2,6,7,12,13,14,15,16,17,18,19,20,21,22,23,24,25,36,
				// -1: LUTS, 0,1,2,36
				fpga.setFAR(startframe_lutconf_num);
				for(int i = 0; i < 37; i++) {
						Frame fr = fpga.getFrame(fpga.getFAR());
						System.out.println(fpga.getFrameData());
						System.out.println(fr);
						FrameData frda = fr.getData();
						System.out.println("FrameData.size(): " + frda.size());
						if(i == selctframe) {
								frda.zeroData();
								for(int j = 0; j < frda.size(); j++) {
										//if (rand.nextInt(41) > 30) {
										//int k = rand.nextInt();
										//System.out.println("rand" + k);
										frda.setData(j, -1);
												//}
								}
								//frda.setData(15, 65536);
								// if(i % 2 == 0)
								// 		frda.setData(10, 1);
								// else
								// 		frda.setData(11, 1);
								fr.configure(frda);
								System.out.println(fr);
						}
						fpga.incrementFAR();
				}
				// here we're done because ocnfiguration is immediatly written
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
				if(false) {
						int startFrame = 0;
						int defaultNumberOfFrames = FrameAddressRegister.getNumberOfFrames(partInfo);

						System.out.println(partInfo);
						System.out.println(fpga.getFrameContents(startFrame, defaultNumberOfFrames));
				}

				// write bitstream
				// create header
				//System.out.println(bsh);
				//System.out.println(fpga.getDeviceSpecification()); == partInfo
				//BitstreamHeader bsh = new BitstreamHeader("blub.ncd", partInfo.getDeviceName());
				BitstreamHeader bsh = new BitstreamHeader("fourlut_sa.ncd", "5vlx50ff676");
				System.out.println(bsh);
				BitstreamGenerator bsg = partInfo.getBitstreamGenerator();
				System.out.println(bsg);
				Bitstream bs = bsg.createPartialBitstream(fpga, bsh);
				//System.out.println(bs);
				bsg.writeBitstreamToBIT(bs, "fourlut_sa_modded.bit");
				// create fpga: already exists
				// create BitstreamGenerator
		}
}