//converts pixels to Density-independent Pixels
function dip(px, dpi)
{
    if(dpi < 120)
        return px;
    else return px * (dpi / 160);
}
