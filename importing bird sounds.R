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
#search for Yellowhammer (Emberiza citrinella) recordings in the UK, limiting the length to 5 to 25 secs
robin_songs <- query_xc(qword = 'Erithacus rubecula cnt:"united kingdom" type:song len:5-25', download = FALSE)

chaffinch_songs <- query_xc(qword = 'Fringilla coelebs cnt:"united kingdom" type:song len:5-25', download = FALSE)

yellowhammer_songs <- query_xc(qword = 'Emberiza citrinella cnt:"united kingdom" type:song len:5-25', download = FALSE)

robin_songs
#shows lots of info including quality (A highest, E lowest), other sp heard in the clip etc
#map samples
map_xc(robin_songs, leaflet.map = TRUE)

#make folders for downloading audios
dir.create(file.path("robin_songs"))
dir.create(file.path("chaffinch_songs"))
dir.create(file.path("yellowhammer_songs"))
# Download the .MP3 files into three separate sub-folders
query_xc(X = robin_songs, path="robin_songs")
query_xc(X = chaffinch_songs, path="chaffinch_songs")
query_xc(X = yellowhammer_songs, path="yellowhammer_songs")

#use this next bit of code to rename files for each species

old_files <- list.files("robin_songs", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-robin_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)

#do the same for the chaffinch song files
old_files <- list.files("chaffinch_songs", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-chaffinch_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)
#finally for yellowhammer files
old_files <- list.files("yellowhammer_songs", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-yellowhammer_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)

#put these files in a new subfolder in the project called bird_audio
dir.create(file.path("bird_audio"))
file.copy(from=paste0("robin_songs/",list.files("robin_songs")),
          to="bird_audio")
file.copy(from=paste0("chaffinch_songs/",list.files("chaffinch_songs")),
          to="bird_audio")
file.copy(from=paste0("yellowhammer_songs/",list.files("yellowhammer_songs")),
          to="bird_audio")
#use mp32wav func in warbleR to convert these mp3s to .wav files
mp32wav(path="blackbird_audio", dest.path="blackbird_audio")
unwanted_mp3 <- dir(path="blackbird_audio", pattern="*.mp3")
#then remove the mp3 files
file.remove(paste0("blackbird_audio/", unwanted_mp3))