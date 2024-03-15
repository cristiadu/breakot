extends Node2D

@export var total_levels = 5

var game_started = false
var game_paused = false
var game_muted = false
var current_level_number = 0
var current_level = null

const LEVEL_PATH = "res://levels/"
const GAME_WON_MESSAGE = "You Won The Game!\nPress ESC to go back to title screen."
const GAME_LOST_MESSAGE = "Game Over!\nPress ESC to go back to title screen."
const LEVEL_WON_MESSAGE = "You Won This Level!\nLoading next one..."
const STARTING_GAME_MESSAGE = "Starting Game..."
const GAME_PAUSED_MESSAGE = "GAME PAUSED."

const LEVEL_WON = "level_won"
const LEVEL_LOST = "level_lost"
const LOST_LIFE = "lost_life"
const TIMEOUT = "timeout"
const ERROR_MESSAGES = {
    LEVEL_WON: "Error when linking behavior of winning a level",
    LEVEL_LOST: "Error when linking behavior of losing a level",
    LOST_LIFE: "Error when linking behavior of losing a life",
    TIMEOUT: "Error when linking behavior of run_game timer"
}
const SIGNALS = {
    $HUD: {LEVEL_WON: on_level_won, LEVEL_LOST: on_level_lost},
    $Ball: {LOST_LIFE: on_life_lost},
    $StartGameTimer: {TIMEOUT: run_game}
}

func _ready():
    for node, signals in SIGNALS:
        for signal, handler in signals:
            connect_signal(node, signal, handler)
    $HUD.show_title_screen()

func connect_signal(node, signal, handler):
    var err = node.get(signal).connect(handler)
    if err:
        print(ERROR_MESSAGES[signal])

func _process(_delta):
    if $HUD/TitleBackground.visible and Input.is_action_just_pressed("ui_accept"):
        current_level_number = 1
        play_sound($StartGameSound)
        start_level(current_level_number)
    if Input.is_action_just_pressed("ui_cancel") and not $HUD/TitleBackground.visible:
        game_started = false
        pause_game_objects()
        play_sound($CancelSound)
        $StartGameTimer.stop()
        $HUD.show_title_screen()
    if Input.is_action_just_pressed("ui_pause") and game_started:
        game_paused = not game_paused
        if game_paused:
            pause_game_objects()
            $HUD.show_message(GAME_PAUSED_MESSAGE, false)
        else:
            unpause_game_objects()
            $HUD.on_timeout_hide_message()
    if Input.is_action_just_pressed("ui_mute"):
        mute_or_unmute_sound(not game_muted)

func on_level_won():
    pause_game_objects()
    if current_level_number < total_levels:
        play_sound($LevelWonSound)
        $HUD.show_message(LEVEL_WON_MESSAGE)
        current_level_number += 1
        await get_tree().create_timer(3).timeout
        start_level(current_level_number)
    else:
        play_sound($GameWonSound)
        game_started = false
        $HUD.show_message(GAME_WON_MESSAGE, false)

func on_level_lost():
    game_started = false
    pause_game_objects()
    play_sound($GameLostSound)
    $HUD.show_message(GAME_LOST_MESSAGE, false)

func on_life_lost():
    play_sound($LifeLostSound)
    $Ball.pause()
    $Ball.reset(current_level.get_node("StartingBallPosition").position)
    $HUD.life_lost()

func run_game():
    game_started = true
    $Ball.reset(current_level.get_node("StartingBallPosition").position)
    $Paddle.reset(current_level.get_node("StartingPaddlePosition").position)
    $HUD.reset()

func start_level(level_number):
    if current_level != null:
        var previous_level = current_level
        remove_child(previous_level)
        previous_level.queue_free()
        
    var level_name = "Level" + str(level_number)
    var level_to_load = load(LEVEL_PATH + level_name + ".tscn")
    current_level = level_to_load.instantiate()
    current_level.set_name(level_name)
    $CollisionWalls.add_sibling(current_level)
    $HUD.hide_title_screen()
    $HUD.show_message(STARTING_GAME_MESSAGE)
    $StartGameTimer.start()

func pause_game_objects():
    $Ball.pause()
    $Paddle.pause()

func unpause_game_objects():
    $Ball.unpause()
    $Paddle.unpause()

func mute_or_unmute_sound(muted):
    var bus_idx = AudioServer.get_bus_index("Master")
    AudioServer.set_bus_mute(bus_idx, muted)
    game_muted = muted

func play_sound(sound):
    sound.play()
