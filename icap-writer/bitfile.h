/* bitfile.h
 *
 * Library routines for dealing with bit files, version 0.2
 *
 * Copyright 2001, 2002 by David Sullins
 *
 * This file is part of Bitinfo.
 * 
 * Bitinfo is free software; you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation, version 2 of the License.
 * 
 * Bitinfo is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 * 
 * You should have received a copy of the GNU General Public License along with
 * Bitinfo; if not, write to the Free Software Foundation, Inc., 59 Temple
 * Place, Suite 330, Boston, MA 02111-1307 USA
 * 
 * You may contact the author at djs@naspa.net.
 */

#include <stdio.h>

/* struct bithead
 *
 * Stores the information obtained from the bitfile header.  Use initbh to
 * initialize the struct, and freebh to free memory allocated for the struct.
 */
struct bithead
{
	char* filename;
	char* part;
	char* date;
	char* time;
	int length;
};

/* initbh
 *
 * Initialize the bithead struct
 */
void initbh(struct bithead *bh);

/* freebh
 *
 * Free up memory allocated for a bithead struct.
 */
void freebh(struct bithead *bh);

/* readhead
 * 
 * Read the entire bit file header.  The file pointer will be advanced to
 * point to the beginning of the bitstream, and the bitfile header struct
 * will be filled with the appropriate data.
 *
 * Return -1 if an error occurs, 0 otherwise.
 */
int readhead(struct bithead *bh, FILE *f);

/* readhead13
 *
 * Read the first 13 bytes of the bit file.  Discards the 13 bytes but
 * verifies that they are correct.
 *
 * Return -1 if an error occurs, 0 otherwise.
 */
int readhead13 (FILE *f);

/* readsecthead
 *
 * Read the header of a bit file section.  The section letter is placed in
 * section buffer "buf" and the length of the following section is 
 * returned.  If buf is NULL, the section letter is discarded.
 *
 * Return -1 if an error occurs, length of section otherwise.
 */
int readsecthead(char *buf, FILE *f);

/* readsection
 *
 * Read a section of a bit file.  The section contents are placed
 * in the contents buffer "buf."
 *
 * Return -1 if an error occurs, 0 otherwise.
 */
int readsection(char *buf, int length, FILE *f);

/* readlength
 *
 * Read in the bitstream length.  The section letter "e" is discarded
 * and the length is returned.
 *
 * Return -1 if an error occurs, length otherwise.
 */
int readlength(FILE *f);

