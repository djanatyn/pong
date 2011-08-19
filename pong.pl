#!/usr/bin/perl -w
use strict;
use warnings;

use SDL;
use SDLx::App;

use SDL::Event;
use SDL::Events;

my $PADDLE_LENGTH = 50;
my $app = SDLx::App->new(width  => 600,
			 height => 480);
my $event = SDL::Event->new();

my $v1 = 0; my $pos1 = 5;
my $v2 = 0; my $pos2 = 200;
my $quit = 0;


sub press_key {
    my $_ = SDL::Events::get_key_name( $event->key_sym );
    if ($_ eq 'up') { $v1 = -1 unless $v1 == 1; } 
    if ($_ eq 'down') { $v1 = 1 unless $v1 == -1; }
    if ($_ eq 'w') { $v2 = -1  unless $v2 == 1; }
    if ($_ eq 's') { $v2 = 1 unless $v2 == -1; }
    if ($_ eq 'q') { $quit = 1; }
}

sub release_key {
    my $_ = SDL::Events::get_key_name( $event->key_sym );
    if ($_ eq 'up') { $v1 = 0; }
    if ($_ eq 'down') { $v1 = 0; }
    if ($_ eq 'w') { $v2 = 0; }
    if ($_ eq 's') { $v2 = 0; }
}

sub process_events {
    SDL::Events::pump_events();
    while ( SDL::Events::poll_event($event) ) {
	press_key() if $event->type == SDL_KEYDOWN;
	release_key() if $event->type == SDL_KEYUP;
    }
    $pos1 += $v1 unless $pos1 + $v1 > 480 - $PADDLE_LENGTH || $pos1 + $v1 < 0;
    $pos2 += $v2 unless $pos2 + $v2 > 480 - $PADDLE_LENGTH || $pos2 + $v2 < 0;
}

my $b_xpos = 240; my $b_ypos = 300;
my $b_xvel = 1;   my $b_yvel = 1;
sub ball_bounce {
    if ($b_xpos == 20 && $b_ypos > $pos1 && $b_ypos < $pos1 + $PADDLE_LENGTH) { $b_xvel *= -1; }
    if ($b_xpos == 580 && $b_ypos > $pos2 && $b_ypos < $pos2 + $PADDLE_LENGTH) {$b_xvel *= -1; }
    if ($b_ypos == 0 || $b_ypos == 480) { $b_yvel *= -1; }
    if ($b_xpos == 0 || $b_xpos == 600) {
	$b_xpos = 240; $b_ypos = 300;
	$b_xvel = 1;   $b_yvel = 1;
    }
    $b_xpos += $b_xvel;
    $b_ypos += $b_yvel;
}

while (!$quit) {
    process_events;
    ball_bounce;
    $app->draw_rect( [0,0,640,480], [0,0,0,255] );
    $app->draw_rect( [20,$pos1,2,$PADDLE_LENGTH], [0,255,0,255] );
    $app->draw_rect( [580,$pos2,2,$PADDLE_LENGTH], [255,0,0,255] );
    $app->draw_rect( [$b_xpos,$b_ypos,5,5], [255,255,255,255] );
    $app->update();
}
