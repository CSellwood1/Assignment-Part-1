#importing bird sound
library(behaviouR)
library(tuneR)
library(seewave)
library(ggplot2)
library(dplyr)
library(warbleR)#for importing xeno-canto website
library(stringr) # part of tidyverse for sorting folders

#search for European robin (Erithacus rubecula) recordings in the UK, limiting the length to 5 to 25 secs
#search for Chaffinch (Fringilla coelebs) recordings in the UK, limiting the length to 5 to 25 secs
#search for Nuthatch (Sitta europaea) recordings in the UK, limiting the length to 5 to 25 secs
robin_songs <- query_xc(qword = 'Erithacus rubecula cnt:"united kingdom" type:song len:5-25', download = FALSE)

chaffinch_songs <- query_xc(qword = 'Fringilla coelebs cnt:"united kingdom" type:song len:5-25', download = FALSE)

nuthatch_songs <- query_xc(qword = 'Sitta europaea cnt:"united kingdom" type:song len:5-25', download = FALSE)

blackbird_songs
#shows lots of info including quality (A highest, E lowest), other sp heard in the clip etc
#map samples
map_xc(blackbird_songs, leaflet.map = TRUE)

#make folders for downloading audios
dir.create(file.path("blackbird_songs"))
dir.create(file.path("blackbird_alarm"))
# Download the .MP3 files into two separate sub-folders
query_xc(X = blackbird_songs, path="blackbird_songs")
query_xc(X = blackbird_alarm, path="blackbird_alarm")
#use this next bit of code to rename files to be either song or alarm files


old_files <- list.files("blackbird_songs", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-song_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)
#do the same for the alarm call files
old_files <- list.files("blackbird_alarm", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-alarm_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)
#put these files in a new subfolder in the project called blackbird_audio
dir.create(file.path("blackbird_audio"))
file.copy(from=paste0("blackbird_songs/",list.files("blackbird_songs")),
          to="blackbird_audio")
file.copy(from=paste0("blackbird_alarm/",list.files("blackbird_alarm")),
          to="blackbird_audio")
#use mp32wav func in warbleR to convert these mp3s to .wav files
mp32wav(path="blackbird_audio", dest.path="blackbird_audio")
unwanted_mp3 <- dir(path="blackbird_audio", pattern="*.mp3")
#then remove the mp3 files
file.remove(paste0("blackbird_audio/", unwanted_mp3))