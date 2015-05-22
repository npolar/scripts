import csv
import json
import sys
from pprint import pprint
from bitstring import BitArray

def read_format(path):
  format = []
  with open(path) as tsv:
    for row in csv.DictReader(tsv, delimiter='\t'):
      row['Start Byte'] = int(row['Start Byte'])
      row['Start Bit'] = int(row['Start Bit'])
      row['Bit Length'] = int(row['Bit Length'])
      row['Min'] = float(row['Min'])
      row['Max'] = float(row['Max'])
      format.append(row)
  return format

def parse_binary(format, path):
  doc = {}
  with open(path, 'rb') as fd:
    array = BitArray(fd)

    for row in format:
      offset = (row['Start Byte'] - 1) * 8 + (8 - row['Start Bit']) # perfectly logical, metocean
      x = array[offset:offset+row['Bit Length']].uint
      y = eval(row['Decoding Equation'])
      doc[row['Data Name']] = y
      #print "%s ==> %s" % (x, y,)
      #print "%s\t%s Min=%s, Max=%s" % (row['Data Name'], y, row['Min'], row['Max'],)

  print json.dumps(doc)

format = read_format(sys.argv[1])
parse_binary(format, sys.argv[2])
