import json
import gzip
import os
import numpy as np

# Temporarily for now. Remove when we can write to DB
import csv

# Read data from .json file
def load_data(file_name, head = 500):
    count = 0
    data = []
    with gzip.open(file_name) as fin:
        for l in fin:
            d = json.loads(l)
            count += 1
            data.append(d)
            
            # break if reaches the 100th line
            if (head is not None) and (count > head):
                break
    return data
    
# Display Keys
def display_key(data):
    for key in reviews[0]:
        print(key)
        print('\n')

# Write to file
def write_data_to_csv(dir, file, data):
    with open(dir + file + '.csv', 'w', newline='') as data_file:
        data_writer = csv.writer(data_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        for attr in data[0]:
            data_writer.writerow([attr])
            
# TO DO: Write data to DB instead of csv

# Read reviews file
DIR = 'C:/Users/Batman/OneDrive - University of Florida/CIS 4301/ProjectRepo/booktrends/data_wrastlin/' #Should be changed to relative
reviews = load_data(os.path.join(DIR, 'goodreads_reviews_spoiler.json.gz'))

#display_keys(reviews)

#Write review to file
write_data_to_csv(DIR, 'review', reviews)