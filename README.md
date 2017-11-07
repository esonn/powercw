# cw-drill
cw-drill is a simple training application for learning morse code (CW). It
generates randomized but configurable text patterns and can play the
corresponding morse code on an audio device using the cw(1) command line utility
available on basically all Unix-like systems. You can input the morse sequence
when it's played, and the script will then give you both strings for comparison,
as well as a rough similarity calculation.

Options:
*   -a                    Include alphabet (a-z)
*   -n                    Include numbers (0-9)
*   -s                    Include special characters
*   -chars=<characters>   Include only given characters
*   -toad=<num>           Include first <num> characters from toad sequence
*   -2 to -8              Give in groups of 2-8
*   -cq                   Always start with preamble 'cq cq cq '
*   -pre                  Always start with preamble 'vvv '
*   -run                  Run cw(1) utility to echo generated string
*   -wait                 Wait for 2 seconds before starting cw
*   -wpm                  --wpm option passed to cw (default: 20)
*   -gap                  --gap option passed to cw (default: 10)
*   -tone                 --tone option passed to cw (default: 700)
*   -h, -help             Show this help text

The given similarity metric is calculated using the Levensthein distance.
Providing feedback on how good your interpretation of the played audio was is
not utterly simple. A character-by-character comparison could tell you how much
% you got right, but fails even if you e.g. skip or add a character which hasn't
been in the original sequence. Levensthein provides a reasonable trade-off,
which doesn't suffer from this problem too much, but isn't too intuitive either
- just get used to it (lower numbers are better).
