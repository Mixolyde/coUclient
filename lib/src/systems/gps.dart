part of couclient;

class Edge {
	String start,end;
	int weight;

	Edge();
	Edge.fromValues(this.start,this.end,{weight:1});
}

class Graph {
	List<Edge> _edges = [];

	List<Edge> get edges => _edges;
	void set edges(List<Edge> e) {
		_edges = e;
	}

	setEdge(String start, String end, {weight:1}) {
		_edges.add(new Edge.fromValues(start,end,weight:weight));
	}
}

class GPS {
	static Graph _worldGraph;

	static set worldGraph(Graph g) {
		_worldGraph = g;
	}

	static Future initWorldGraph() async {
		_worldGraph = decode(await HttpRequest.getString('worldGraph.txt'),type:Graph);
	}

	static List<String> getRoute(String from, String to) {
		return _dijkstra(_worldGraph,from,to);
	}

	static _dijkstra(Graph graph, String source, String target) {
		Set<String> vertices = new Set();
		Map<String,List<Map>> neighbours = {};
		graph.edges.forEach((Edge edge) {
			vertices.add(edge.start);
			vertices.add(edge.end);
			if(neighbours.containsKey(edge.start)) {
				neighbours[edge.start].add({'end':edge.end,'cost':edge.weight});
			} else {
				neighbours[edge.start] = [{'end':edge.end,'cost':edge.weight}];
			}
			if(neighbours.containsKey(edge.end)) {
				neighbours[edge.end].add({'end':edge.start,'cost':edge.weight});
			} else {
				neighbours[edge.end] = [{'end':edge.start,'cost':edge.weight}];
			}
		});

		Map<String,num> dist = {};
		Map<String,String> previous = {};
		vertices.forEach((String vertex) {
			dist[vertex] = double.INFINITY;
		});
		dist[source] = 0;

		List<String> Q = new List()..addAll(vertices);
		String u;
		int lastLength = Q.length;
		while(Q.length > 0) {
			print(Q.length);
			num min = double.INFINITY;
			Q.forEach((String vertex) {
				if(dist[vertex] < min) {
					min = dist[vertex];
					u = vertex;
				}
			});

			Q.remove(u);
			if(Q.length == lastLength) {
				print("Couldn't find path to $target");
				return [];
			} else {
				lastLength = Q.length;
			}
			if(dist[u] == double.INFINITY || u == target) {
				break;
			}

			if(neighbours.containsKey(u)) {
				neighbours[u].forEach((Map arr) {
					num alt = dist[u] + arr['cost'];
					if(alt < dist[arr['end']]) {
						dist[arr['end']] = alt;
						previous[arr['end']] = u;
					}
				});
			}
		}

		List<String> path = [];
		u = target;

		while(previous.containsKey(u)) {
			path.insert(0,u);
			u = previous[u];
		}
		path.insert(0,u);

		return path;
	}
}