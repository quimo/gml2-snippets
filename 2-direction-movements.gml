/**
* Object: obj_player | Event: Create
*/

distance = 5;

/**
* Object: obj_player | Event: Step
*/

// rilevazione del tasto premuto
var key_pressed = keyboard_check(vk_right) - keyboard_check(vk_left);

// spostamento
x += (key_pressed * distance);

// se è premuto un tasto
if (key_pressed != 0){
        // flip orizzontale dello sprite
		image_xscale = key_pressed;
}