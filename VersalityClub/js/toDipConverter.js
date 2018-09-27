//converts pixels to Density-independent Pixels
function toDp(px, dpi)
{
    if(dpi < 120)
        return px;
    else return px * (dpi / 160);
}
