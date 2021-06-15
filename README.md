# TouchAlyticsBAVault
We implemented and evaluated our proposed BAVault using Touchalytics data and named it as TouchAlyticsBAVault. We used MatLab in implemenation and run the Main.m file. 

## BAVault
A BAVault is similary to the fuzzy vault (see link to know about the fuzzy vault:https://ieeexplore.ieee.org/abstract/document/4378259?casa_token=Uxv388LUZr8AAAAA:D1wGXNbUwOwbWTBmk9BDr7OfN1dsoyvGlJtfGEY-mtNHC2UVj9x7XPzsed6glTiocXme4m12hw) and uses behavioral profile X of a BA system rather to lock the vault. The BAVault will open only by using the another behavioral profile Y of the BA system of same user. Here, a BA profile is seen as a collection of sample sets of d features where every feature has its data distribution.

To unlock a BAVault a feature-based matching algorithm employs a similarity function to decide if two sets of samples have same underlying distribution and output a confidence value. A larger output value corresponds to the higher confidence about the 'sameness' of the distributions of two sets. Follow the link (https://link.springer.com/chapter/10.1007/978-3-030-58201-2_20) to know more about BAVault and its unlocking process. 

## Touchalytics
Touchalytics uses users' touch data (up-down and left-right scrolling) when interacting with an app. It uses the collected touch data for user authentication. The system uses 30 behavioral features and data from 41 users. We downloaded touchalytics data from the link http://www.mariofrank.net/touchalytics/. We then cleaned the data by replacing 'NaN' and 'Infinity' by zero and dropped the 'doc id', 'phone id', and 'change of finger orientation' columns.
