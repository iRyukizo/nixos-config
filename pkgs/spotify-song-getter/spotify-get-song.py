#!/usr/bin/env python3

import dbus

try:
    session_bus = dbus.SessionBus()
    spotify_bus = session_bus.get_object(
        'org.mpris.MediaPlayer2.spotify',
        '/org/mpris/MediaPlayer2'
    )

    spotify_properties = dbus.Interface(
        spotify_bus,
        'org.freedesktop.DBus.Properties'
    )

    metadata = spotify_properties.Get(
        'org.mpris.MediaPlayer2.Player', 'Metadata')
    status = spotify_properties.Get(
        'org.mpris.MediaPlayer2.Player', 'PlaybackStatus')

    artist = metadata['xesam:artist'][0] if metadata['xesam:artist'] else ''
    song = metadata['xesam:title'] if metadata['xesam:title'] else ''
    # album = metadata['xesam:album'] if metadata['xesam:album'] else ''

    print(f'{artist} - {song}')

except Exception as e:
    if isinstance(e, dbus.exceptions.DBusException):
        print('')
    else:
        print(e)
