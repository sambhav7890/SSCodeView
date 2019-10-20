#include <bits/stdc++.h>
 
typedef long long ll;
 
using namespace std;
 
#define PI 3.141592653589793238
typedef pair<ll,ll> pll;
typedef map<ll,ll> mll;
typedef set<ll> sl;
typedef pair<double,double> pdd;
typedef vector <ll> vll;
typedef vector <vector <ll> > graph;
typedef vector <vector <pll> > wgraph; 

#define cinll(x) cin >> x
#define cinll2(x,y) cin >> x >> y;
#define cinll3(x,y,z) cin >> x >> y >> z;
#define cinpair(p) cin >> p.fi >> p.se;
#define fi first
#define se second
#define all(c) c.begin(),c.end()
#define mp make_pair
#define pb push_back
#define endl '\n'
#define LOG 25
#define all(c) c.begin(),c.end()

#define tr(...) cout<<__FUNCTION__<<' '<<__LINE__<<" = ";trace(#__VA_ARGS__, __VA_ARGS__)

template<typename S, typename T>
ostream& operator<<(ostream& out,pair<S,T> const& p){out<<'('<<p.fi<<", "<<p.se<<')';return out;}

template<typename T>
ostream& operator<<(ostream& out,vector<T> const& v){
ll l=v.size();for(ll i=0;i<l-1;i++)out<<v[i]<<' ';if(l>0)out<<v[l-1];return out;}

template<typename T>
void trace(const char* name, T&& arg1){cout<<name<<" : "<<arg1<<endl;}

template<typename T, typename... Args>
void trace(const char* names, T&& arg1, Args&&... args){
const char* comma = strchr(names + 1, ',');cout.write(names, comma-names)<<" : "<<arg1<<" | ";trace(comma+1,args...);}

        
#define __                            \
freopen("input.txt", "r", stdin); \
freopen("output.txt", "w", stdout);

const ll MOD = 998244353;
const ll INF = 1e18;
const double EPS = 1e-9;
const int N = 500005;

mt19937 rng(chrono::steady_clock::now().time_since_epoch().count());

int rand(int l, int r)
{
	uniform_int_distribution<int> uid(l, r);
	return uid(rng);
}

vector <vector <ll> > g;
ll ans = 0;
ll k;

ll dfs(ll u, ll p, ll depth)
{
    ll max_depth = depth;
    for(auto v : g[u])
    {
        if(v == p)
        {
            continue;
        }
        max_depth = max(dfs(v, u, depth + 1), max_depth);
    }
    if(max_depth - depth + 1 <= k)
    {
        ans++;
    }
    return max_depth;
}

void solve()
{
    ll t;
    cin >> t;
    while(t--)
    {
        ll k;
        cin >> k;
        ll a[k];
        ll e = 0;
        for(int i = 0; i < k; i++)
        {
            cin >> a[i];
            if(a[i] % 2 == 0)
            {
                e = 1;
            }
        }

        if(k%2 == 0)
        {
            cout << 0 << endl;
        }
        else
        {
            if(e == 1)
            {
                cout << 1 << endl;
            }
            else
            {
                ll ret = 2e18;
                for(int i = 0; i < k; i++)
                {
                    ll num = a[i];
                    ll ans = 1;
                    while(num > 0)
                    {
                        if(num % 2 == 0)
                        {
                            ret = min(ret, ans);
                        }
                        num /= 2;
                        ans *= 2;
                    } 
                }
                if(ret == 2e18)
                {
                    cout << -1 << endl;
                }
                else
                {
                    cout << ret << endl;
                }
            }
        }
    }
}

int32_t main()
{
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);
    solve();

} 
