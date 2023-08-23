from bs4 import BeautifulSoup
from pydub import AudioSegment
import subprocess, json

def get_nve(text_with_tag):
    text_with_tag = text_with_tag.replace('|', '')
    soup =  BeautifulSoup(text_with_tag, "lxml")
    value_tags = soup.find_all(attrs={"value":True})
    nve = ""
    for value_tag in value_tags:
        nve += value_tag['value'] + " "
    return nve

def get_sentence_text(raw_data):
    raw_data = raw_data.strip()
    if not raw_data:
        return
    data = [x.split('\t') for x in raw_data.split('\n') if x]
    text = ""
    for i in data:
        text += i[0] + " "
    text_with_nva = ""
    for i in data:
        if i[8] and i[8]!='|':
            nve = get_nve(i[8])
            text_with_nva +=  "[" + nve + "] "
        text_with_nva += i[0] + " "
        if i[9] and i[9]!='|':
            nve = get_nve(i[9])
            text_with_nva +=  "[" + nve + "] "
    start_time = data[0][51] + '.' + data[0][52]
    end_time = data[-1][53] + '.' + data[-1][54]

    return text, text_with_nva, start_time, end_time

def get_end_time(raw_data):
    raw_data = raw_data.strip()
    if not raw_data:
        return
    data = [x.split('\t') for x in raw_data.split('\n') if x]
    end_time = data[-1][53] + '.' + data[-1][54]

    return end_time

def get_start_time(raw_data):
    raw_data = raw_data.strip()
    if not raw_data:
        return
    data = [x.split('\t') for x in raw_data.split('\n') if x]
    start_time = data[0][51] + '.' + data[0][52]

    return start_time

def process_vrt(vrt_file, mp4_file, output_folder):
    f = open(vrt_file, mode='r')
    strr = f.read()
    f.close()
    soup =  BeautifulSoup(strr, "html.parser")

    sentences = soup.find_all('s')

    cmd = ['ffmpeg','-i', mp4_file, '-ac', '1', '-acodec', 'pcm_s16le', '-ar','16000', '-f', 'wav', '-']
    proc = subprocess.Popen(cmd,stdout=subprocess.PIPE)
    output= proc.communicate()[0]
    audio_file = AudioSegment(output, sample_width=2,channels=1,frame_rate=16000)

    for sentence in sentences:
        text, text_with_nva, start_time, end_time = get_sentence_text(sentence.get_text())
        text_with_nva = text_with_nva.strip()
        text = text.strip()
        if text_with_nva[0] == '[':
            prev_id = int(sentence['id']) - 2
            if prev_id<0:
                start_time=0
            else:
                prev_sentence = sentences[prev_id]
                start_time = get_end_time(prev_sentence.get_text())

        if text_with_nva[-1] == ']':
            next_id = int(sentence['id'])
            next_sentence = sentences[next_id]
            end_time = get_start_time(next_sentence.get_text())
        # print(sentence['id'], '\t', text, '\t', text_with_nva, '\t', start_time, '\t', end_time)
        metadata = {}
        metadata['duration'] = float(end_time) - float(start_time)
        metadata['audiofilepath'] = output_folder + '/audio_chunk_' + sentence['id']+ '.wav'
        metadata['start_time'] = start_time
        metadata['text'] = text
        with open(output_folder+'/samples.json', 'a',encoding="utf-8") as file:
            json.dump(metadata, file)
            file.write(',\n')
        metadata['text'] = text_with_nva

        with open(output_folder + '/samples_with_nve.json', 'a',encoding="utf-8") as file:
            json.dump(metadata, file)
            file.write(',\n')

        # create a new wav file
        audio_chunk=audio_file[float(start_time)*1000:float(end_time)*1000]
        audio_chunk.export( "{}/audio_chunk_{}.wav".format(output_folder,sentence['id']), format="wav")

