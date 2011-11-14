/* bitfile.c
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

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "bitfile.h"

#ifndef uchar
#define uchar unsigned char
#endif

/* first 13 bytes of a bit file */
static uchar head13[] = {0, 9, 15, 240, 15, 240, 15, 240, 15, 240, 0, 0, 1};

/* initbh
 *
 * Initialize the bithead struct
 */
void initbh(struct bithead *bh)
{
	bh->filename = NULL;
	bh->part = NULL;
	bh->date = NULL;
	bh->time = NULL;
	bh->length = 0;
}

/* freebh
 *
 * Free up memory allocated for a bithead struct.
 */
void freebh(struct bithead *bh)
{
	free(bh->filename);
	free(bh->part);
	free(bh->date);
	free(bh->time);
	initbh(bh);
}

/* readhead
 * 
 * Read the entire bit file header.  The file pointer will be advanced to
 * point to the beginning of the bitstream, and the bitfile header struct
 * will be filled with the appropriate data.
 *
 * Return -1 if an error occurs, 0 otherwise.
 */
int readhead(struct bithead *bh, FILE *f)
{
	int t;
	
	/* get first 13 bytes */
	t = readhead13(f);
	if (t) return t;
	
	/* get filename */
	t = readsecthead(NULL, f);
	if (-1 == t) return -1;
	bh->filename = malloc(t);
	t = readsection(bh->filename, t, f);
	
	/* get part name */
	t = readsecthead(NULL, f);
	if (-1 == t) return -1;
	bh->part = malloc(t);
	t = readsection(bh->part, t, f);
	
	/* get file creation date */
	t = readsecthead(NULL, f);
	if (-1 == t) return -1;
	bh->date = malloc(t);
	t = readsection(bh->date, t, f);
	
	/* get file creation time */
	t = readsecthead(NULL, f);
	if (-1 == t) return -1;
	bh->time = malloc(t);
	t = readsection(bh->time, t, f);
	
	/* get bitstream length */
	t = readlength(f);
	if (-1 == t) return -1;
	bh->length = t;
	
	return 0;
}

/* readhead13
 *
 * Read the first 13 bytes of the bit file.  Discards the 13 bytes but
 * verifies that they are correct.
 *
 * Return -1 if an error occurs, 0 otherwise.
 */
int readhead13 (FILE *f)
{
	int t;
	uchar buf[13];

	/* read header */
	t = fread(buf, 1, 13, f);
	if (t != 13)
	{
		return -1;
	}
	
	/* verify header is correct */
	t = memcmp(buf, head13, 13);
	if (t)
	{
		return -1;
	}
	
	return 0;
}

/* readsecthead
 *
 * Read the header of a bit file section.  The section letter is placed in
 * section buffer "buf" and the length of the following section is 
 * returned.  If buf is NULL, the section letter is discarded.
 *
 * Return -1 if an error occurs, length of section otherwise.
 */
int readsecthead(char *buf, FILE *f)
{
	int t;
	char tbuf = 0;
	char lenbuf[2];
	
	/* if buf is NULL, use tbuf instead */
	if (NULL == buf)
	{
		buf = &tbuf;
	}

	/* get section letter */
	t = fread(buf, 1, 1, f);
	if (t != 1)
	{
		return -1;
	}
	
	/* read length */
	t = fread(lenbuf, 1, 2, f);
	if (t != 2) 
	{
		return -1;
	}

	/* convert 2-byte length to an int */
	return (((int)lenbuf[0]) <<8) | lenbuf[1];
}


/* readsection
 *
 * Read a section of a bit file.  The section contents are placed
 * in the contents buffer "buf."
 *
 * Return -1 if an error occurs, 0 otherwise.
 */
int readsection(char *buf, int length, FILE *f)
{
	int t;
	
	/* get section data */
	t = fread(buf, 1, length, f);
	if ((t != length) || (buf[length-1] != 0))
	{
		return -1;
	}
	
	return 0;
}

/* readlength
 *
 * Read in the bitstream length.  The section letter "e" is discarded
 * and the length is returned.
 *
 * Return -1 if an error occurs, length otherwise.
 */
int readlength(FILE *f)
{
	char s = 0;
	uchar buf[4];
	int length;
	int t;
	
	/* get section, make sure it's "e" */
	t = fread(&s, 1, 1, f);
	if ((t != 1) || (s != 'e'))
	{
		return -1;
	}
	
	/* get length */
	t = fread(buf, 1, 4, f);
	if (t != 4)
	{
		return -1;
	}
	
	/* convert 4-byte length to an int */
	length = (((int)buf[0]) <<24) | (((int)buf[1]) <<16) 
	         | (((int)buf[2]) <<8) | buf[3];
	
	return length;
}
