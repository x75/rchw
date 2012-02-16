/* 
 * FrameModderLogic, to be run within the rapidsmith framework
 *
 * read bitstream, change some of the logic configuration
 *  - change LUT config
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
public class FrameModderLogic {

		public static final String STARTFRAME_OPTION_STRING = "s";
		public static final String LUT_CONFIG_STRING = "l";
		public static final int LUTCONF_LENGTH = 16;

		public static void main(String[] args) {
				/** Setup option parser **/
				BitstreamOptionParser cmdLineParser = new BitstreamOptionParser();
				cmdLineParser.addInputBitstreamOption();
				cmdLineParser.addOutputBitstreamOption();
				cmdLineParser.addHelpOption();
				// custom options
				cmdLineParser.accepts(STARTFRAME_OPTION_STRING, "Specify start frame for LUT configuration area").withRequiredArg().ofType(Integer.class);;
				cmdLineParser.accepts(LUT_CONFIG_STRING, "Specify LUT configuration bits as string").withRequiredArg().ofType(String.class);;
				// cmdLineParser.addPartNameOption();
				// cmdLineParser.addRawReadbackInputOption();

				OptionSet options = null;
				try {
						//options = cmdLineParser.parse(args);
						options = cmdLineParser.parseArgumentsExitOnError(args);
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

				boolean haveOutputBitstream = 
						options.has(BitstreamOptionParser.OUTPUT_BITSTREAM_OPTION);
				boolean haveStartframe =
						options.has(STARTFRAME_OPTION_STRING);
				boolean haveLUTConfig =
						options.has(LUT_CONFIG_STRING);

				// option -o / output bitstream
				String outputBitstreamFileName = "blub.bit";
				if(haveOutputBitstream) {
						outputBitstreamFileName = cmdLineParser.getOutputFileNameStringExitOnError(options);
						System.out.println("have output bitstream option: " + outputBitstreamFileName);
				}

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

				// option -l / lutconfig
				String lutconf = "0000000000000001";
				if(haveLUTConfig) {
						lutconf = (String)options.valueOf(LUT_CONFIG_STRING);
						System.out.println("LUT config: " + lutconf);
						// // print single constituent characters
						// for(int i=0; i<lutconf.length(); i++) {
						// 		System.out.println("LUT config: " + i + ": " + lutconf.charAt(i));
						// }
				}
				// setup config bits
				int[] bitconf;
				bitconf = new int[LUTCONF_LENGTH];
				for(int i=0; i<lutconf.length(); i++) {
						bitconf[(LUTCONF_LENGTH-1)-i] = Integer.valueOf(String.valueOf(lutconf.charAt(i)));
						System.out.println("LUT config: " + i + ": " + bitconf[i]);
				}

				// setup bit positions
				int[] bitpos03 = {688, 696, 692, 700, 690, 698, 694, 702, 689, 697, 693, 701, 691, 699, 695, 703};
				int[] bitpos12 = {689, 697, 693, 701, 691, 699, 695, 703, 688, 696, 692, 700, 690, 698, 694, 702};
				
				/////////////////////////////////////////////////////////////////////
				// 1. Parse bitstream
				/////////////////////////////////////////////////////////////////////
				FPGA fpga = null;
		
				fpga = cmdLineParser.createFPGAFromBitstreamOrReadbackFileExitOnError(options);

				XilinxConfigurationSpecification partInfo = fpga.getDeviceSpecification();

				System.out.println("partInfo:");
				System.out.println(partInfo);

				ArrayList<Frame> fpgaConfiguredFrames = fpga.getConfiguredFrames();
				System.out.println("Number of configured Frames:" + fpgaConfiguredFrames.size());

				int firstConfiguredFrame = fpgaConfiguredFrames.get(0).getFrameAddress();
				FrameAddressRegister far = new FrameAddressRegister(partInfo, firstConfiguredFrame);
				FrameAddressRegister far_bramstart = new FrameAddressRegister(partInfo, 3146240);
				System.out.println("first configured frame FAR: " + firstConfiguredFrame);
				System.out.println("first configured frame FAR: " + far);

				// save bitstream copy before modifications
				
				//System.exit(0);

				// for BRAM changes
				// grab a frame, change it, and write it back
				if(true) {
						System.out.println("in action routine");
						//fpga.setFAR(70426);
						//fpga.setFAR(0x0001131A);
						fpga.setFAR(startframe_lutconf_num);
						for(int i = 0; i < 4; i++) {
								Frame fr = fpga.getFrame(fpga.getFAR());
								FrameData frda = fr.getData();
								//System.out.println("getFrameData:\n" + fpga.getFrameData());
								System.out.println("Frame:\n" + fr);

								// print frame-bits
								int k = 1;
								System.out.print(k + ": ");
								for(int j = 0; j < (frda.size() * 32); j++) {
										System.out.print(frda.getBit(j));
										if((j % 32) == 31) {
												System.out.println();
												k++;
												System.out.print(k + ": ");
										}
								}
								System.out.println();

								switch(i) {
								case 0:
								case 3:
										// frda.setBit(660, 1);
										// frda.setBit(668, 0);
										//frda.setBit(688, 0);
										//frda.setBit(696, 1);
										for(int j = 0; j<lutconf.length(); j++) {
												if(frda.setBit(bitpos03[j], bitconf[j]))
														System.out.print(frda.getBit(bitpos03[j]) + ":" + lutconf.charAt(j) + ", ");
										}
										break;
								case 1:
								case 2:
										// frda.setBit(660, 0);
										// frda.setBit(668, 0);
										// frda.setBit(689, 0);
										// frda.setBit(697, 1);
										for(int j = 0; j<lutconf.length(); j++) {
												if(frda.setBit(bitpos12[j], bitconf[j]))
														System.out.print(frda.getBit(bitpos03[j]));
										}
										break;
								// case 2:
								// 		break;
								// case 3:
								// 		break;
								default:
										break;
								}

								// print frame as int-list
								
								// FrameData frda = fr.getData();
								// frda.zeroData();
								// //frda.setData(15, 65536);
								// if(i % 2 == 0)
								// 		frda.setData(10, 1);
								// else
								// 		frda.setData(11, 1);
								// fr.configure(frda);
								// System.out.println(fr);
								fpga.incrementFAR();
						}
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
								// fd.clear();
								// 
								cfar = fd.getFrameAddress();
								far.setFAR(cfar);


								fData = fd.getData();
								if(!fData.isEmpty()) {
										System.out.println(">===========================================================");
										System.out.println("FAR Address: " + cfar);
										System.out.println("fd.class: " + fd.getClass() + "\nfar: " + far);
										System.out.println(fd + "\n");
										System.out.println("<===========================================================");
								}
								// System.out.println("Frame data size: " + fData.size());
								// System.out.println("Frame data:\n" + fData);
								// fDataInts = fData.getAllFrameWords();
								// System.out.println(fDataInts);

								// blockTypeString = AbstractConfigurationSpecification.getBlockType(partInfo, far.getBlockType());
								// System.out.println(blockTypeString);
								// if(far.getAddress() == far_bramstart.getAddress()) {
								// 		System.out.println("found BRAM Block start");
								// 		// set data attempt #1
								// 		fData.zeroData();
								// 		fDataInts = fData.getAllFrameWords();
								// 		fDataInts.set(15, 65536);
								// 		System.out.println(fDataInts);

								// 		// set data attempt #2
								// 		fData.setData(15, 65536);

								// 		// FrameData fDataNew = new FrameData(fDataInts.toArray());
								// 		System.out.println("Frame data new:\n" + fData);
								// }
								// if(blockTypeString.equals("BRAM")) {
								// 		System.out.println("found BRAM Frame");
								// }
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

				// // System.out.println(fpga.configData.length);
				// System.out.println(fpga.getFAR());

				// // 2. start work
				// int startFrame = 0;
				// int defaultNumberOfFrames = FrameAddressRegister.getNumberOfFrames(partInfo);

				// System.out.println(fpga.getFrameContents(startFrame, defaultNumberOfFrames));


				if(haveOutputBitstream) {
						// write bitstream
						// create header
						//System.out.println(bsh);
						//System.out.println(fpga.getDeviceSpecification()); == partInfo
						//BitstreamHeader bsh = new BitstreamHeader("blub.ncd", partInfo.getDeviceName());
						BitstreamHeader bsh = new BitstreamHeader("id_lut0001_routed.ncd", "5vfx70tff1136");
						System.out.println(bsh);
						BitstreamGenerator bsg = partInfo.getBitstreamGenerator();
						System.out.println(bsg);
						Bitstream bs = bsg.createPartialBitstream(fpga, bsh);
						//System.out.println(bs);
						bsg.writeBitstreamToBIT(bs, outputBitstreamFileName);
						// create fpga: already exists
						// create BitstreamGenerator
				}
		}
}