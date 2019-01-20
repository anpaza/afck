/* Simple tool to get the numeric value of file capabilities.
 * Copyright (c) 2019 by Andrey Zabolotnyi <zapparello@ya.ru>
 * Placed in the public domain.
 */

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <sys/capability.h>

#define handle_error(msg) \
    { perror(msg); exit(EXIT_FAILURE); }

int main (int argc, char *argv [])
{
	bool verbose = false;

	if (argc == 1) {
		printf ("Usage: %s [file1 ...]\n", argv [0]);
		printf ("\nPrints the numeric representation of file capabilities,\n");
		printf ("as used by 'make_ext4fs -C' capabilities= attribute\n");
		exit (EXIT_FAILURE);
	}

	if (argc > 2)
		verbose = true;

	for (int i = 1; i < argc; i++) {
		cap_t caps = cap_get_file (argv [i]);
		if (caps == NULL)
			handle_error ("cap_get_file");

		unsigned long long acaps = 0;
		for (int j = 0; j <= CAP_LAST_CAP; j++) {
			cap_flag_value_t val;
			if (cap_get_flag (caps, j, CAP_PERMITTED, &val))
				handle_error ("cap_get_flag");

			if (val == CAP_SET)
				acaps |= (1ULL << j);
		}

		cap_free (caps);
		if (verbose)
			printf ("%s 0x%llx\n", argv [i], acaps);
		else
			printf ("0x%llx\n", acaps);
	}

    exit (EXIT_SUCCESS);
}
