/**
* - Creare un livello "Istance" di nome "Camera”
* - Creare un oggetto "obj_camera" e posizionarlo nel livello
* https://www.yoyogames.com/en/tutorials/cameras-and-views
* IL PROBLEMA DI QUESTO APPROCCIO E' CHE LA VISTA "TREMA"
* QUANDO IL PLAYER SI MUOVE IN DIAGONALE
*/

/**
* Object: obj_camera | Event: Create
*/

#macro viewport_width 320	
#macro viewport_height 320

// abilita la prima "vista"
view_enabled = true;
view_visible[0] = true;

// imposta le dimensioni della "vista"
view_xport[0] = 0;
view_yport[0] = 0;
view_wport[0] = viewport_width;
view_hport[0] = viewport_height;


// imposta una camera che "filma" quella vista seguendo il player
view_camera[0] = camera_create_view(0, 0, viewport_width, viewport_height, 0, obj_player, -1, -1, viewport_width/2, viewport_height/2);

// imposta la finestra di gioco al centro della viewport del monitor
var _dwidth = display_get_width();
var _dheight = display_get_height();
var _xpos = (_dwidth / 2) - viewport_width;
var _ypos = (_dheight / 2) - viewport_height;
window_set_rectangle(_xpos, _ypos, viewport_width, viewport_height);
surface_resize(application_surface, viewport_width, viewport_height);