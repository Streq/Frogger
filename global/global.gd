extends Node

export var PLAYER : PackedScene

export (Array, PackedScene) var levels

const TILE_SIZE := 16

const LIVES := 2

var current_lives = LIVES
var current_score = 0
var hiscore = 0
