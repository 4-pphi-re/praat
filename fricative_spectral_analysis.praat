# This script is for spectral analysis of fricatives
# You can get these parameters (see Shadle(2023) for details)
# fm = frequency of main peak
# am = amplitude at fm
# fmin = frequency of minimum in low-frequency band
# amin = amplitude at fmin
# ad = am - amin
# This script is motivated by Will Styler's origianl script
# last updated: 25.01.05. Mina Cho

# Setting the directory path. The user must manually specify the path below.
directory$ = "path"

# Preparing the log file
filedelete 'directory$'fricative-log.txt

header_row$ = "Filename" + tab$ + "phoneme" + tab$ + "fm" + tab$ + "am" + tab$ + "fmin" + tab$ + "amin" + tab$ + "ad" + newline$
header_row$ > 'directory$'fricative-log.txt

# Loading the audio files
Create Strings as file list...  list 'directory$'*.wav
number_files = Get number of strings

# Iterating through files
# This script assumes noise is marked in tier 3. Modify as needed for your data.
for i from 1 to number_files
    select Strings list
    current_token$ = Get string... 'i'
    Read from file... 'directory$''current_token$'

    object_name$ = selected$ ("Sound")

    Read from file... 'directory$''object_name$'.TextGrid

    select TextGrid 'object_name$'

    number_of_intervals = Get number of intervals... 3

    # Looping through intervals within a file
    for j from 1 to number_of_intervals
        select TextGrid 'object_name$'
        label$ = Get label of interval... 3 'j'
        # Preparing the spectrum. This script assumes a window size of 20ms.
        if label$ <> ""
            startpoint = Get starting point... 3 'j'
            endpoint = Get end point... 3 'j'
            midpoint = startpoint + ((endpoint - startpoint)/2)
            leftT = midpoint - 0.01
            rightT = midpoint + 0.01
            select Sound 'object_name$'
            Extract part... leftT rightT "hamming" 1 "yes"

            Filter (pre-emphasis)... 50
            To Spectrum (fft)

            To Ltas (1-to-1)

            numbins = Get number of bins

            # Initialization
            freqsum = 0
            ampsum = 0
            freqminsum = 0
            ampminsum = 0
            threshold = 0.5
            amin = 100

            # search peaks and a minimum
            # A bin is considered a peak if its amplitude is higher than the previous and the next bin
            for b from 2 to numbins - 1
                c = b-1
                d = b+1
                bf = Get frequency from bin number... 'b'
                ba = Get value in bin... 'b'

                # for fmin
                if (bf > 550) and (bf < 4000) and (ba < amin) 
                    amin = ba
                    fmin = bf

                # for fm
                else
                    if bf > 4000 and bf < 10000
                        ba = Get value in bin... 'b'
                        ba_prev = Get value in bin... 'c'
                        ba_next = Get value in bin... 'd'

                        if (ba > ba_prev) and (ba > ba_next) and (ba > threshold)
                            freqsum = freqsum + (ba * bf)
                            ampsum = ampsum + ba
                        endif
                    endif
                endif
            endfor

            # calculate fm, am, ad
            # for ease of compulation, am is approximated as the amplitude of nearest bin from fm
            if ampsum > 0
                fm = freqsum / ampsum
                bin_width = Get bin width
                bin_number_m = round(fm / bin_width)
                if bin_number_m >= 1 and bin_number_m <= numbins
                    am = Get value in bin... bin_number_m
                else
                    if bin_number_m < 1
                        am = Get value in bin... 1
                    else
                        am = Get value in bin... numbins
                    endif
                endif
                ad = am - amin
                fileappend "'directory$'fricative-log.txt" 'object_name$''tab$''label$''tab$''fm''tab$''am''tab$''fmin''tab$''amin''tab$''ad''newline$'
            endif
        endif
    endfor

    select all
    minus Strings list
    Remove
endfor

select all
Remove
clearinfo
print All files have been processed.  What next?
