# BAVaultTouchAlytics
We implemented and evaluated our proposedBAVault using Touchalytics data.  Touchalytics uses users' touch data (up-down and left-right scrolling) when interacting with an app. It uses the collected touch data for user authentication. The system uses 30 behavioral features and data from 41 users. 

We downloaded touchalytics data from the link http://www.mariofrank.net/touchalytics/. We then cleaned the data by replacing `NaN' and `Infinity' by zero and dropped the `doc id', `phone id', and `change of finger orientation' columns. Touchalytics data before using them.
