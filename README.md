# cw-drill
cw-drill is a simple training application for learning morse code (CW). It
generates randomized but configurable text patterns and can play the
corresponding morse code on an audio device using the cw(1) command line utility
available on basically all Unix-like systems and Linux distributions. You can
input the morse sequence when it's played, and the script will then give you
both strings for comparison, as well as a rough similarity calculation.

## Command-line options
### Character classes
    -a                    Include alphabet (a-z)
    -n                    Include numbers (0-9)
    -s                    Include special characters
    -chars=<characters>   Include only given characters
    -toad=<num>           Include first <num> characters from toad sequence

### Grouping/help
    -2 to -8              Give in groups of 2-8 (i.e. create words)
    -h, -help             Show help text

### Prefixing and initial waiting
    -cq                   Always start with preamble 'cq cq cq '
    -pre                  Always start with preamble 'vvv '
    -wait                 Wait for 2 seconds before starting cw

### Play CW on audio device
    -run                  Run cw(1) utility to echo generated string
    -wpm                  --wpm option passed to cw (default: 20)
    -gap                  --gap option passed to cw (default: 10)
    -tone                 --tone option passed to cw (default: 700)

The given similarity metric is calculated using the Levensthein distance.
Providing feedback on how good your interpretation of the played audio was is
not utterly simple. A character-by-character comparison could tell you how much
% you got right, but fails even if you e.g. skip or add a character which hasn't
been in the original sequence. Levensthein provides a reasonable trade-off,
which doesn't suffer from this problem too much, but isn't too intuitive either
- just get used to it (lower numbers are better).

## Example(s)
Create 3-letter words using only the letters F, L, D and U. A total number of
30 characters are created, and the corresponding morse code is played using
beeps on your audio device:
    cw-drill -chars "fldu" -3 -run 30




