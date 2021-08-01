/**
* - Creare un livello "Istance" di nome "Camera”
* - Creare un oggetto "obj_camera" e posizionarlo nel livello
* https://www.yoyogames.com/en/tutorials/cameras-and-views
*/

/**
* Object: obj_camera | Event: Create
*/

#macro viewport_width 320	
#macro viewport_height 320
#macro lerp_amount 0.1

// abilita la prima "vista"
view_enabled = true;
view_visible[0] = true;

// imposta le dimensioni d ella "vista"
view_xport[0] = 0;
view_yport[0] = 0;
view_wport[0] = viewport_width;
view_hport[0] = viewport_height;


// imposta una camera che "filma" quella vista
view_camera[0] = camera_create_view(0, 0, viewport_width, viewport_height, 0, -1, -1, -1, viewport_width/2, viewport_height/2);

// imposta la finestra di gioco al centro della viewport del monitor
var _dwidth = display_get_width();
var _dheight = display_get_height();
var _xpos = (_dwidth / 2) - (viewport_width / 2);
var _ypos = (_dheight / 2) - (viewport_height / 2);
window_set_rectangle(_xpos, _ypos, viewport_width, viewport_height);
surface_resize(application_surface, viewport_width, viewport_height);

/**
* Object: obj_camera | Event: Step
*/

// posizione attuale della camera
var current_camera_x = camera_get_view_x(view_camera[0]);
var current_camera_y = camera_get_view_y(view_camera[0]);

// posizione che la camera deve raggiungere (player sempre a centro schermo)
var camera_x = clamp(obj_player.x - (viewport_width/2), 0, room_width - viewport_width);
var camera_y = clamp(obj_player.y - (viewport_height/2), 0, room_height - viewport_height);

// sposta la camera "verso" la posizione del player con una interpolazione del 10% (segue in ritardo)
camera_set_view_pos(view_camera[0], lerp(current_camera_x, camera_x, lerp_amount), lerp(current_camera_y, camera_y, lerp_amount));


