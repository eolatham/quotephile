#!/usr/bin/env python3

# STL
import logging

# PDM
from flask import Flask
from flask_cors import CORS

# LOCAL
from public.constants import *

logging.basicConfig(
    level=logging.INFO,
    format="[%(asctime)s] [%(filename)20s:%(lineno)-4s] [%(levelname)8s]   %(message)s",
)
LOGGER = logging.getLogger(__name__)

######################################### APP ##########################################

APP = Flask(__name__)
CORS(APP)

######################################## ROUTES ########################################


######################################### MAIN #########################################

if __name__ == "__main__":
    APP.run(host="localhost", port=5000, debug=True)
