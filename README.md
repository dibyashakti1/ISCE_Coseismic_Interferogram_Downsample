Script to quadtree downsample the unwrapped co-seismic interferograms (unw.geo) from ISCE 

The quadtreeMain.m script downsamples the interseismic unwrapped interferrograms from ISCE output

quadtreeExtractISCE and quadtreeISCE functions are required to run the entire routine

3-columns input: [lon, lat, LOS] to perform quadtree downsampling

Modified the quadtree function available in the GBIS

May change the following parameters to lower/increase the degree of downsampling
thresh = 2;
maxlevel = 10;
startlevel = 1;


# One example interferogram of the 2025 Myanmar earthquake from ALOS-2 data
![untitled1](https://github.com/user-attachments/assets/59a76e7f-e581-4d7e-a38c-32d7a83685ec)



![untitled2](https://github.com/user-attachments/assets/5969bbfe-1761-4dda-a233-0df8dbc29f48)
