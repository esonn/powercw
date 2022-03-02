# powercw: Enhance your morse (CW) skills!

powercw is a simple training application for learning morse code (CW). It
generates/assembles strings according to given command-line options and plays it
on your audio device using morse code. While listening, simply input every
letter you understood (conclude with Enter). Both strings (the one given and
your copy) are then printed, together with a how many errors you made and
percentage you got right (using the Levensthein distance, if you're interested
in technicalities).

There are 3 main modes:
* Group mode: Give classic 5-character groups (character classes or 
    a particular list of character can be configured)
* Word mode: Give a number of random English words of different sizes
* German sentence mode: Assemble German sentences

Wordlists are integrated and resemble the 10000 most used words in Google
searches (from https://github.com/first20hours/google-10000-english).

German sentence generator and associated data by davidak, stolen from
https://github.com/davidak/satzgenerator - many thanks to David.

Dependencies are low, only a Perl5 interpreter is needed for sequence
generation, and the cw(1) utility for playback. cw(1) is packaged 
differently in distributions: Debian has the "cw" package, Arch the "unixcw"
package.

(c) Erik Sonnleitner 2018. See https://github.com/esonn/powercw
    es&lt;at&gt;delta-xi.net | erik.sonnleitner&lt;at&gt;fh-hagenberg.at


### Command-line options
#### Word mode (standard mode)
    -short                Include short words (<=4 chars)
    -medium, -med         Include medium length words (<=6 chars)
    -long                 Include long words (>6 chars)
    -num, -n              Include numbers (0-9) between words
    -special, -s          Include special characters between words

#### Group mode
    -groups               Enable group mode
    -groupsize=<size>     Change number of characters per group
    -alpha, -a            Include alphabet (a-z)
    -num, -n              Include numbers (0-9)
    -special, -s          Include special characters
    -chars=<characters>   Include only given characters (invalid with (-a, -n, -s)

#### German sentence generator
    -german               Give syntactically correct but semantically questionable German sentences.

#### Prefixing and initial waiting
    -cq                   Always start with preamble 'cq cq cq '
    -pre                  Always start with preamble 'vvv '
    -wait                 Wait for 2 seconds before starting cw

#### Play CW on audio device
    -nocw                 Do not play CW code on audio device (doesn't use cw(1))
    -wpm                  --wpm option passed to cw (words per minute, default: 20)
    -gap                  --gap option passed to cw (inter-character gap, default: 10)
    -tone                 --tone option passed to cw (frequency in Hz, default: 700)

#### Others
    -l,-list              Display international morse code table
    -h,-help              Show help


#### Type what you hear & compare to what was sent
Unless -nocw is used, the generated sequence is played back using cw(1). During
playback, you can just input character after character as you hear the
corresponding morse code. If the transmission ended, simply hit enter.

The program will then show both texts, the one originally sent and the one
copied by you so you can easily spot errors.

The given score is calculated using the Levensthein distance. Providing feedback
on how good your copy of the audio morse transmission was is not utterly simple.
A character-by-character comparison fails even if you e.g. skip or add
a character which hasn't been in the original sequence. Levensthein provides
a reasonable trade-off, which doesn't suffer from this problem too much but
isn't perfect either. It roughly computes the number of wrong characters (in
many, not all cases), from which the score percentage is calculated.
I'm sure there are better ways, but I tend to be lazy and prefer simple things.

Providing a longer gap with -gap is a good thing to start with. You should
practice understanding morse code in close to regular speed (say, 20-25 wpm),
but use longer gaps between characters and words to give your brain time to
process what you heard (that's the Farnsworth idea).

### Example(s)
Greate 4 character groups of 3 characters each, including only the predefined
characters "a", "d", "e", "n" and "t". Also, start the transmission with
3 CQ calls (as usual in radio transmissions) and a speed of 15 words per
minute.

    ./powercw -chars "adent" -wpm 15 -cq -groups -groupsize 3 4

    cq cq cq ede aae wtn dax 
    CW message:  cq cq cq ede aae ntn dan
    Your copy:   cq cq cq ede aae wtn dax 
    Your score:  87% (~3 errors)
      --Seems OK!

Create 8 randomized English words of medium size (4-6 chars) including random
punctuation characters here and there.

    ./powercw -med -s 8

Create random German sentences, give quite fast :)

    ./powercw -german -wpm 22 -gap 6

    CW message:  <Mein Freund wirkt cool auf einer Insel.>
    Your copy:   <mein freund wirkt cool auf einer insel.>
    Your score:  100% (~0 errors)
      --Your copy was excellent!
        Try higher WPM/lower gap/longer messages.

