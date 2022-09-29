import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from neupy import algorithms
from neupy.layers import *

from hurst import compute_Hc

df = pd.read_csv('PETR4.SA.csv')    # read database containing closing price

# compute Hurst coefficient
hurst, c, data = compute_Hc(df['Close'], kind='price', simplified=True)

f, ax = plt.subplots()
ax.plot(data[0], c*data[0]**hurst, color="deepskyblue")
ax.scatter(data[0], data[1], color="purple")
ax.set_xscale('log')
ax.set_yscale('log')
ax.set_xlabel('Time interval')
ax.set_ylabel('R/S ratio')
ax.grid(True)
plt.show()

print("H={:.4f}, c={:.4f}".format(hurst, c))

x = df.drop(['Close'], axis=1).values
y = df['Close'].values