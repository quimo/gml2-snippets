/**
* Object: obj_player | Event: Create
*/

distance = 5;

/**
* Object: obj_player | Event: Step
*/

// rilevazione del tasto premuto
var key_right = keyboard_check(vk_right);
var key_left = keyboard_check(vk_left);
var key_down = keyboard_check(vk_down);
var key_up = keyboard_check(vk_up);

// vincolo del movimento sui 4 assi (no diagonale)
if (key_right) {
	x += distance;
} else if (key_left) {
	x -= distance;
} else if (key_up) {
	y -= distance;
} else if (key_down) {
	y += distance;
}