import os
import json
import gspread
from oauth2client.service_account import ServiceAccountCredentials


def pull(path):
    scope = ['https://spreadsheets.google.com/feeds']
    keyfile = path.decode('utf-8')
    credentials = ServiceAccountCredentials.from_json_keyfile_name(
        keyfile, scope)
    gcu = gspread.authorize(credentials)
    spreadsheet = gcu.open('Events and Professionals Contact List')
    worksheet = spreadsheet.worksheet('events')
    records = worksheet.get_all_records()
    return json.dumps(records)
