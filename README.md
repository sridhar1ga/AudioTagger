# AudioTagger

As a part of the extension to the RedHen AudioTagger Project by Saby, We have aimed to develop an Audio tagging system using the News corpus available at RedHen Labs.  
  
Structure of Data

The news data contains a video file of a program (MP4 file), and its transcript (TXT file) and a word by word timestamped transcript with the audio effects in VRT file.

Example folder structure: https://umbc.app.box.com/s/u2cx5y3qzgm8qtdng4q71tcb5ickq3z2

  

We can't make use of the large video files in the corpus directly for creating an AudioTagger. We have to create a dataset out of the existing Video and the corresponding VRTs data. To do that, I have created a parser, which gets the sentences out of the VRTs along with the start timestamp and end timestamp.

  

VRT Parser

I have used Beautifulsoup Package to parse the VRT files. With the information extracted from VRT files, I have created audio chunks as well as manifest files for the same.

  

Problems with the above approach

- Some chunks are misaligned and have a duration of 0 seconds.
- Some chunks got transcript that is not part of the chunk.
- In some chunks the audio was correct, but a little of the transcription got affected by the end time stamp being a little before than expected 
- Some chunks got the Start timestamp a little after the original start

To address these problems, we are deploying a forced aligner to get the correct timestamps for the video files.
