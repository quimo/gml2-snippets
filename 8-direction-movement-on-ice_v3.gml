/**
* Object: obj_player | Event: Create
*/

player_speed_h = 0;
player_speed_v = 0;
player_speed_max = 4;
player_acceleration = 0.1;
player_deceleration = 0.04;
player_stop_movement_threshold = 60;
player_stop_vertical_movement_timing = 0;
player_stop_horizontal_movement_timing = 0;

key_right = 0;
key_left = 0;
key_down = 0;
key_up = 0;

function setDecelerationTimer() {
    // timer per la decelerazione orizzontale
    if (key_right + key_left != 0) {
        // se sto premendo tasti di movimento il timer per la frenata si resetta
        player_stop_horizontal_movement_timing = 0;
    } else {
        // se non premo nessun tasto il timer scorre
        player_stop_horizontal_movement_timing++;
    }  
    // timer per la decelerazione verticale
    if (key_up + key_down != 0) {
        // se sto premendo tasti di movimento il timer per la frenata si resetta
        player_stop_vertical_movement_timing = 0;
    } else {
        // se non premo nessun tasto il timer scorre
        player_stop_vertical_movement_timing++;
    }
}

function horizontaldecelerationTimerReached() {
    if (player_stop_horizontal_movement_timing >= player_stop_movement_threshold) {
        return true;
    }
    return false;
}

function verticaldecelerationTimerReached() {
    if (player_stop_vertical_movement_timing >= player_stop_movement_threshold) {
        return true;
    }
    return false;
}

function decelerate(direction) {
    if (direction == "horizontal") {
        if (player_speed_h > 0) {
        player_speed_h -= player_deceleration;
        } else if (player_speed_h < 0) {
            player_speed_h += player_deceleration;
        }
    } else if (direction == "vertical") {
        if (player_speed_v > 0) {
        player_speed_v -= player_deceleration;
        } else if (player_speed_v < 0) {
            player_speed_v += player_deceleration;
        }
    }
}

function checkMovementAndSetSpeed() {
    if (key_right) {
        // accelero a destra
        if (player_speed_h < player_speed_max) player_speed_h += player_acceleration;
    }
        
    if (key_left) {
        // accelero a sinistra
        if (player_speed_h > -player_speed_max) player_speed_h -= player_acceleration;
    }

    if (key_up) {
        // accelero in alto
        if (player_speed_v > -player_speed_max) player_speed_v -= player_acceleration;
    }

    if (key_down) {
        // accelero in basso
        if (player_speed_v < player_speed_max) player_speed_v += player_acceleration;
    }
}

function move() {
    var movement_direction = point_direction(0, 0, player_speed_h, player_speed_v);
    x += lengthdir_x(abs(player_speed_h), movement_direction);
    y += lengthdir_y(abs(player_speed_v), movement_direction);
}

/**
* Object: obj_player | Event: Step
*/

key_right = keyboard_check(vk_right);
key_left = keyboard_check(vk_left);
key_down = keyboard_check(vk_down);
key_up = keyboard_check(vk_up);

// timer per la decelerazione
setDecelerationTimer();

// controllo la pressione dei tati di movimento e imposto la velocità
checkMovementAndSetSpeed();

// sposto il player (applica la correzione per il movimento in diagonale)
move();

// se il timer è stato raggiunto
if (horizontaldecelerationTimerReached()) {
	// decelero
	decelerate("horizontal");
}
// se il timer è stato raggiunto
if (verticaldecelerationTimerReached()) {
	// decelero
	decelerate("vertical");
}