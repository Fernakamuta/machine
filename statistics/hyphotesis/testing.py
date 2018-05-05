import scipy.stats as st

# Get z-score from p-value (To the left)
print(st.norm.ppf(0.09012267246445244))

# Get p-Value from normal a Z-score (AREA TO THE LEFT)
print(st.norm.cdf(-1.34))
