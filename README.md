Set of scripts to downsample the unwrapped co-seismic interferograms (unw.geo) from ISCE using the "quadtree"  method

The quadtreeMain.m script downsamples the interseismic unwrapped interferrograms from ISCE output

quadtreeExtractISCE and quadtreeISCE functions are required to run the entire routine

3-columns input: [lon, lat, LOS] to perform quadtree downsampling

Use "save_gmt.py" in ISCE to convert the "unw.geo" file to "grd" file

May use GMT to convert grd to xyz file (grd2xyz)

Getting xyz from GMT may provide large datasets (in millions), may spatial downsample first before giving input

Modified the quadtree function available in the GBIS

May change the following parameters to lower/increase the degree of downsampling
thresh = 2;
maxlevel = 10;
startlevel = 1;


# Example: Co-seismic interferogram of the 2025 Myanmar earthquake from ALOS-2 data
![untitled1](https://github.com/user-attachments/assets/59a76e7f-e581-4d7e-a38c-32d7a83685ec)



![untitled2](https://github.com/user-attachments/assets/5969bbfe-1761-4dda-a233-0df8dbc29f48)
