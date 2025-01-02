# Script to calculate the intensity of specified points.
# Supports processing of multiple points in multiple files.
# Based on the script framework by Katherine Crosswhite.
# Last modified: 25.01.02. Mina Cho

# Path where the audio files are stored

directory$ = "directory name"

# Delete existing log file

filedelete 'directory$'energy-log.txt

# Header row for the log file

header_row$ = "Filename" + tab$ + "phoneme" + tab$ + "energy" + newline$
header_row$ > 'directory$'energy-log.txt

# Process multiple audio files (number_files)

Create Strings as file list...  list 'directory$'*.wav
number_files = Get number of strings

for j from 1 to number_files

     select Strings list
     current_token$ = Get string... 'j'
     Read from file... 'directory$''current_token$'

     object_name$ = selected$ ("Sound")

     Read from file... 'directory$''object_name$'.TextGrid

     select TextGrid 'object_name$'

     # Process multiple points (number_of_points) in each file
     number_of_points = Get number of points... 2
     for b from 1 to number_of_points
         select TextGrid 'object_name$'
          label$ = Get label of point... 2 'b'
          if label$ <> ""

            # Based on a window size of 0.01. You may adjust window size by adding or subtracting ((desired window size) / 2) from midpoint.
	       midpoint = Get time of point... 2 'b'
	       leftT = midpoint - 0.005
               rightT = midpoint + 0.005
               select Sound 'object_name$'

            # Calculate burst energy for each point
            # To change the window type, replace "hamming" with another option
	       Extract part... leftT rightT "hamming" 1 "yes"             
               burst_energy = Get energy... 0 0

               # Save to the log file
               fileappend "'directory$'energy-log.txt" 'object_name$''tab$''label$''tab$''burst_energy''newline$'
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