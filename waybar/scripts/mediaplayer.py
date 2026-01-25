#!/usr/bin/env python3
import gi
gi.require_version("Playerctl", "2.0")
from gi.repository import Playerctl, GLib
from gi.repository.Playerctl import Player

import argparse
import logging
import sys
import signal
import json
import os
from typing import List

logger = logging.getLogger(__name__)


def signal_handler(sig, frame):
    sys.stdout.write("\n")
    sys.stdout.flush()
    sys.exit(0)


class PlayerManager:
    def __init__(self, selected_player=None, excluded_player=None):
        self.manager = Playerctl.PlayerManager()
        self.loop = GLib.MainLoop()

        self.selected_player = selected_player
        self.excluded_player = excluded_player.split(",") if excluded_player else []

        self.manager.connect("name-appeared", self.on_player_appeared)
        self.manager.connect("player-vanished", self.on_player_vanished)

        signal.signal(signal.SIGINT, signal_handler)
        signal.signal(signal.SIGTERM, signal_handler)

        self.init_players()

    def init_players(self):
        for name in self.manager.props.player_names:
            if name.name in self.excluded_player:
                continue
            if self.selected_player and name.name != self.selected_player:
                continue
            self.init_player(name)

    def init_player(self, player_name):
        player = Playerctl.Player.new_from_name(player_name)
        player.connect("metadata", self.on_metadata_changed)
        player.connect("playback-status", self.on_playback_status_changed)
        self.manager.manage_player(player)
        self.on_metadata_changed(player, player.props.metadata)

    def run(self):
        self.loop.run()

    def get_players(self) -> List[Player]:
        return self.manager.props.players

    def get_active_player(self):
        players = self.get_players()
        for p in reversed(players):
            if p.props.status == "Playing":
                return p
        return players[0] if players else None

    def write_output(self, text, player):
        output = {
            "text": text,
            "class": f"custom-{player.props.player_name}",
            "alt": player.props.player_name
        }
        sys.stdout.write(json.dumps(output) + "\n")
        sys.stdout.flush()

    def clear_output(self):
        sys.stdout.write("\n")
        sys.stdout.flush()

    def on_playback_status_changed(self, player, status):
        self.on_metadata_changed(player, player.props.metadata)

    def on_metadata_changed(self, player, metadata):
        artist = player.get_artist()
        title = player.get_title()

        if not title:
            self.clear_output()
            return

        track = f"{artist} - {title}" if artist else title
        icon = "" if player.props.status == "Playing" else ""

        current = self.get_active_player()
        if current and current.props.player_name == player.props.player_name:
            self.write_output(f"{icon} {track}", player)

    def on_player_appeared(self, _, player_name):
        if player_name.name in self.excluded_player:
            return
        if self.selected_player and player_name.name != self.selected_player:
            return
        self.init_player(player_name)

    def on_player_vanished(self, *_):
        player = self.get_active_player()
        if player:
            self.on_metadata_changed(player, player.props.metadata)
        else:
            self.clear_output()


def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("--player")
    parser.add_argument("-x", "--exclude")
    parser.add_argument("-v", "--verbose", action="count", default=0)
    parser.add_argument("--enable-logging", action="store_true")
    return parser.parse_args()


def main():
    args = parse_arguments()

    if args.enable_logging:
        logfile = os.path.join(os.path.dirname(__file__), "media-player.log")
        logging.basicConfig(
            filename=logfile,
            level=logging.DEBUG,
            format="%(asctime)s %(levelname)s:%(message)s"
        )

    logger.setLevel(max((3 - args.verbose) * 10, 0))

    manager = PlayerManager(args.player, args.exclude)
    manager.run()


if __name__ == "__main__":
    main()
