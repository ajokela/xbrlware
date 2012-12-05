#!/usr/bin/env python

import sys

sys.path.append("gen-py")

from thrift.transport import TTransport
from thrift.transport import TSocket
from thrift.protocol import TBinaryProtocol

from risk import Rating
from risk.ttypes import *

transport = TTransport.TBufferedTransport(TSocket.TSocket("localhost", "9090"))
protocol = TBinaryProtocol.TBinaryProtocol(transport)

client = Rating.Client(protocol)
transport.open()

print client.piotroski("JAVA")
print client.altman_z("GOOG")