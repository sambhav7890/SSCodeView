#include <bits/stdc++.h>
using namespace std;
//#define cerr if (false) cerr
#define db(x) cerr << #x << "=" << x << endl
#define db2(x, y) cerr << #x << "=" << x << "," << #y << "=" << y << endl
#define db3(x, y, z) cerr << #x << "=" << x << "," << #y << "=" << y << "," << #z << "=" << z << endl
#define dbv(v) cerr << #v << "="; for (auto _x : v) cerr << _x << ", "; cerr << endl
#define dba(a, n) cerr << #a << "="; for (int _i = 0; _i < (n); ++_i) cerr << a[_i] << ", "; cerr << endl
template <typename A, typename B>
ostream& operator<<(ostream& os, const pair<A, B>& x) {
	return os << "(" << x.first << "," << x.second << ")";
}
typedef long long ll;
typedef long double ld;
struct Pt {
	ll x, y;
	Pt() {}
	Pt(ll x, ll y) : x(x), y(y) {}
	Pt operator+(const Pt& p) const { return Pt(x + p.x, y + p.y); }
	Pt operator-(const Pt& p) const { return Pt(x - p.x, y - p.y); }
	Pt operator*(ll c) const { return Pt(x * c, y * c); }
	Pt operator/(ll c) const { return Pt(x / c, y / c); }
	bool operator==(const Pt& p) const { return x == p.x && y == p.y; }
	bool operator!=(const Pt& p) const { return !(*this == p); }
	bool operator<(const Pt& p) const { return x == p.x ? y < p.y : x < p.x; }
	bool operator>(const Pt& p) const { return !(*this == p || *this < p); }
	ll abs2() { return x * x + y * y; }
};
ostream& operator<<(ostream& os, const Pt& p) {
	return os << "(" << p.x << "," << p.y << ")";
}
inline ll dist2(Pt a, Pt b) {
	ll dx = a.x - b.x;
	ll dy = a.y - b.y;
	return dx * dx + dy * dy;
}
// Positive if b is to the left of a
inline ll cross(const Pt& a, const Pt& b) { return a.x * b.y - a.y * b.x; }
inline int ccw(Pt p, Pt q, Pt r) {
	ll v = cross(p - q, p - r);
	if (v < 0) return -1;
	if (v > 0) return 1;
	return 0;
}
inline ll dot(const Pt& a, const Pt& b) { return a.x * b.x + a.y * b.y; }
// compute distance from c to segment between a and b
ld distancePointSegment(Pt a, Pt b, Pt c) {
	ll r = dist2(b, a);
	if (!r) return sqrtl(dist2(a, c));
	ll s = dot(c - a, b - a);
	if (s < 0) return sqrtl(dist2(a, c));
	if (s > r) return sqrtl(dist2(b, c));
	ld m = (ld)s / r;
	ld dx = a.x + (b.x - a.x) * m;
	ld dy = a.y + (b.y - a.y) * m;
	return sqrt(dx * dx + dy * dy);
}
pair<vector<Pt>, vector<Pt>> upperLowerHull(vector<Pt> p) {
	sort(p.begin(), p.end(), [](const Pt& a, const Pt& b) {
		if (a.x != b.x) return a.x < b.x;
		return a.y < b.y;
	});
	vector<Pt> up, dn;
	for (int i = 0; i < p.size(); ++i) {
		while (up.size() > 1 &&
			ccw(up[up.size() - 2], up.back(), p[i]) >= 0) up.pop_back();
		while (dn.size() > 1 &&
			ccw(dn[dn.size() - 2], dn.back(), p[i]) <= 0) dn.pop_back();
		up.push_back(p[i]);
		dn.push_back(p[i]);
	}
	return {up, dn};
}
vector<Pt> convexHull(const vector<Pt>& p) {
	vector<Pt> up, dn;
	tie(up, dn) = upperLowerHull(p);
	reverse(up.begin(), up.end());
	for (int i = 1; i + 1 < up.size(); ++i)
		dn.push_back(up[i]);
	return dn;
}
int pointInConvexPolygon(const Pt& p, const vector<Pt>& upper, const vector<Pt>& lower) {
	if (upper.size() == 1 && lower.size() == 1) return upper[0] == p ? 0 : -1;
	assert(upper.size() >= 2 && lower.size() >= 2);
	assert(upper[0] == lower[0] && upper.back() == lower.back());
	if (p < upper[0] || p > upper.back()) return -1;
	auto it = lower_bound(upper.begin() + 1, upper.end(), p);
	int a = ccw(*it, *prev(it), p);
	if (a <= 0) return a;
	it = lower_bound(lower.begin() + 1, lower.end(), p);
	return ccw(*prev(it), *it, p);
}
vector<Pt> minkowskiSum(vector<Pt> a, vector<Pt> b) {
	if (a.size() > b.size()) swap(a, b);
	if (a.size() == 1) {
		for (auto& p : b) p = p + a[0];
		return b;
	}
	auto cmp = [](const Pt& p, const Pt& q) {
		return p.y != q.y ? p.y > q.y : p.x < q.x;
	};
	rotate(a.begin(), min_element(a.begin(), a.end(), cmp), a.end());
	rotate(b.begin(), min_element(b.begin(), b.end(), cmp), b.end());
	auto angleCmp = [](const Pt& a, const Pt& b) {
		assert((a.x || a.y) && (b.x || b.y));
		if (a.y < 0 && b.y >= 0) return true;
		if (a.y >= 0 && b.y < 0) return false;
		if (!a.y && !b.y) return a.x > b.x;
		return a.x * b.y > b.x * a.y;
	};
	int n = a.size(), m = b.size();
	vector<Pt> v(n + m), av(n), bv(m), ret;
	for (int i = 0; i < n; ++i) av[i] = a[i + 1 == n ? 0 : i + 1] - a[i];
	for (int i = 0; i < m; ++i) bv[i] = b[i + 1 == m ? 0 : i + 1] - b[i];
	merge(av.begin(), av.end(), bv.begin(), bv.end(), v.begin(), angleCmp);
	Pt p = a[0] + b[0];
	for (auto& delta : v) {
		ret.push_back(p);
		p = p + delta;
	}
	return ret;
}
int main() {
	int TC;
	scanf("%d", &TC);
	assert(TC <= 1000);
	while (TC--) {
		int n, m;
		scanf("%d", &n);
//		assert(n >= 3 && n <= 100000);
		vector<Pt> a(n);
		for (int i = 0; i < n; ++i) {
			scanf("%lld%lld", &a[i].x, &a[i].y);
			assert(abs(a[i].x) <= 1000000000);
			assert(abs(a[i].y) <= 1000000000);
		}
		scanf("%d", &m);
//		assert(m >= 3 && m <= 100000);
		vector<Pt> b(m);
		for (int i = 0; i < m; ++i) {
			scanf("%lld%lld", &b[i].x, &b[i].y);
			assert(abs(b[i].x) <= 1000000000);
			assert(abs(b[i].y) <= 1000000000);
			b[i].x = -b[i].x;
			b[i].y = -b[i].y;
		}
		a = convexHull(a);
		b = convexHull(b);
		auto c = minkowskiSum(a, b);
		vector<Pt> uc, lc;
		tie(uc, lc) = upperLowerHull(c);
		Pt origin(0, 0);
		if (pointInConvexPolygon(origin, uc, lc) >= 0) {
			printf("-1\n");
		} else {
			ld ans = 1e100;
			for (int i = 0; i < c.size(); ++i) {
				int ni = i + 1 == c.size() ? 0 : i + 1;
				ans = min(ans, distancePointSegment(c[i], c[ni], origin));
			}
			printf("%.9Lf\n", ans);
		}
	}
}


