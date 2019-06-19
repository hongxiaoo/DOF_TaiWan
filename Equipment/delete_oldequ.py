import os
import re
import tqdm

def file_name(file_dir):
    file_path = []
    for root, dirs, files in os.walk(file_dir):
        for file in files:
            file_path.append(os.path.join(root, file))
    return file_path

def delete_oldequ(file_path):
    try:
        content = open(file_path, 'r', encoding='utf-8').read()

        if '(舊)' in content:


def get_code(file_path):


if __name__ == '__main__':
    with open('C:\\DOF - 副本\\equipment\\equipment.kor.str') as code:

    for file_path in file_name():
