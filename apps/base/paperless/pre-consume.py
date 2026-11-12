#!/usr/bin/env python3
# Drop the OOXML creation date: Tika would report it and Paperless would skip content dates
import os
import re
import zipfile

path = os.environ["DOCUMENT_WORKING_PATH"]
if zipfile.is_zipfile(path):
    tmp = path + ".tmp"
    with zipfile.ZipFile(path) as src, zipfile.ZipFile(tmp, "w") as dst:
        for item in src.infolist():
            data = src.read(item)
            if item.filename == "docProps/core.xml":
                data = re.sub(rb"<dcterms:created\b.*?</dcterms:created>", b"", data, flags=re.S)
            dst.writestr(item, data)
    os.replace(tmp, path)
