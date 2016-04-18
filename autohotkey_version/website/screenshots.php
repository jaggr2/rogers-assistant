<?php
/////////////////////////////////
//  Copyrights by Roger Jaggi          //
/////////////////////////////////

$site_title = "Screenshots";
$site_description = "Screenshots zu Rogers Assistant.";
$site_keywords = "Screenshots, Rogers Assistant, Rogers Assistent, Roger Jaggi, Bildschirmfotos";

$button_home = "passive";
$button_funktionen = "passive";
$button_screenshots = "active";
$button_dokumentation = "passive";
$button_download = "passive";

$showimage = "";
if( isset($_GET['showimage']) )
{
	$showimage = $_GET['showimage'];
}
 
if($showimage == 3)
{
	$currenttext = "Detaileinstellungen";
	$currentimage = "images/screenshot_shortcutfenster.png";
}
else if($showimage == 2)
{
	$currenttext = "Einstellungen";
	$currentimage = "images/screenshot_einstellungsfenster.png";
}
else{
	$currenttext = "Statusübersicht";
	$currentimage = "images/screenshot_statusfenster.png";
}

include("./header.html");
?>
<h1>Screenshots</h1>
<p>So sieht Rogers Assistant aus:<a id="oben"> </a></p>
<br />
<br />
<p class="center"><a href="screenshots.php?showimage=1#oben"><img src="images/thumbnail_statusfenster.png" alt=" Screenshot Statusfenster " title=" Screenshot Statusfenster " /></a>  <a href="screenshots.php?showimage=2#oben"><img src="images/thumbnail_einstellungsfenster.png" alt=" Screenshot Einstellungen " title=" Screenshot Einstellungen " /></a>  <a href="screenshots.php?showimage=3#oben"><img src="images/thumbnail_shortcutfenster.png" alt=" Screenshot Detaileinstellungen " title=" Screenshot Detaileinstellungen " /></a></p>
<br />
<br />
<br />
<h3 class="center"><?php echo $currenttext; ?></h3>
<p class="center"><img src="<?php echo $currentimage; ?>" alt=" Screenshot <?php echo $currenttext; ?> " title=" Screenshot <?php echo $currenttext; ?> " /></p>
<br />
<br />
<?php
include("./footer.html");
exit;
?>
