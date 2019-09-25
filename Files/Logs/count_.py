# 2019/09/25 12:15:31
"""
	Used in the session "res free# JVEMV6 44#7.2.1_ 12 / 44. currency / 7. mql prog / 2. eap-2 / 1. id-1 / 20190925_122320"
	Count the number of occurrence of "step : 6 : j2 : X"
	
	Result ==> >>> print("m1 = %d" % len(m1)) ==> "Y"
					m1 = 27
				>>> print("m2 = %d" % len(m2)) ==> "N"
					m2 = 34
				>>>

"""

import re

fpath = "C:\\Users\\iwabuchiken\\AppData\\Roaming\\MetaQuotes\\Terminal\\34B08C83A5AAE27A4079DE708E60511E\\MQL4\\Files\\Logs\\20190924_115309[eap-2.id-1].[EURJPY-15].dir\\[eap-2.id-1].(20190924_115309).log"

f = open(fpath, "r")

lines = f.read()

f.close()

#ref https://docs.python.org/3/howto/regex.html
reg1 = "step : 6 : j2 : Y"
reg2 = "step : 6 : j2 : N"

p1 = re.compile(reg1)
p2 = re.compile(reg2)

m1 = p1.findall(lines)
m2 = p2.findall(lines)

print("m1 = %d" % len(m1))
print("m2 = %d" % len(m2))

