# System: Routing Engine

## Overview

Calculates a route between two station IDs using the static metro graph, then converts that path into display-ready route segments, travel time, and transfer count.

## How It Works

### Graph Model

The route graph is built implicitly whenever the service explores neighbors:

- Each station is a node.
- Adjacent stations on the same line are connected by their order in `MetroLine.stationIds`.
- Walking transfers are connected by each station's `transferTo` list.
- Bend points in `MetroLine.path` are ignored because they are visual-only.

### Path Finding

The implementation uses Dijkstra-style shortest path search, but every edge currently has the same cost:

- Moving one station on the same line costs `1`.
- Walking through a transfer also costs `1` during path finding.
- Transfer penalties are not used while choosing the path.

Because all edge costs are equal, the selected route is effectively the fewest graph edges, not necessarily the fewest transfers or the fastest real-world route.

### Segment Building

After a station path is found, the service splits it into route segments:

1. Start with the first station's line.
2. Keep adding stations while the line ID stays the same.
3. When the next station is on a different line:
   - Close the current metro segment.
   - Insert a transfer segment between the previous station and the new station.
   - Start a new metro segment on the new line.
4. Add the final metro segment.

Transfer segments have:

- `isTransfer = true`
- empty line ID
- the two station IDs involved in the transfer
- `fromStationId` and `toStationId` set for future UI/detail use

### Time Calculation

The time estimate is calculated after segment building:

```
Total Time =
  sum(non-transfer segment gaps * 2 minutes)
  + sum(transfer segments * 3 minutes)
```

Rules:

- Travel between adjacent stations: 2 minutes.
- Each transfer: 3 minutes.
- Same-station route: 0 minutes.

## Data Flow

```
User selects from/to stations
    |
    v
MapScreen calls RouteService.findRoute(fromId, toId)
    |
    v
Shortest path search over MetroData station order and transfer links
    |
    v
Route path is split into metro and transfer segments
    |
    v
Total time and transfer count are calculated
    |
    v
MetroRoute is returned to map highlighting and route details sheet
```

## Edge Cases

| Scenario | Handling |
|----------|----------|
| Same station selected | Returns an empty route with time 0 and 0 transfers |
| Unknown start or end ID | Search cannot produce a path and returns `null` |
| No graph connection exists | Returns `null` |
| Transfer edge changes line | Creates a transfer segment between the two station records |
| Path begins or ends at transfer station | Treated like any other station |
| Circle line loop expected | Not handled as a closed loop unless the data explicitly connects the last and first station |

## Assumptions

- All stations are open.
- All trains are running.
- Transfer walking time is always 3 minutes.
- Station-to-station ride time is always 2 minutes.
- The best user route is the fewest graph edges, not weighted by transfer inconvenience.
- `transferTo` entries should be symmetric in the data; otherwise routes may differ by direction.

## Dependencies

- `MetroData.stations` for all route nodes.
- `MetroData.lines` for ordered same-line adjacency.
- `Station.transferTo` for transfer edges.
- `MetroRoute` and `RouteSegment` for the display contract.

## Future Improvements

- Add transfer penalties during path finding so the chosen route better matches the time estimate.
- Add line-specific travel times and transfer-specific walking times.
- Support alternative route modes such as fastest, fewest transfers, and fewest stops.
- Validate that all transfer pairs are bidirectional.
- Add station closure or service disruption support if real-time or manually maintained status becomes available.
