#include<bits/stdc++.h>
using namespace std;
typedef long long ll;

ll const M = 500;
vector<ll> prime,matchL(M),matchR(M),dist(M);
ll bases[M][3],target[M][3];
ll X,Y,T;
vector< vector<ll> > graph(M);
ll inf = 12345678-1;

void pre(){
    ll i,j;
    ll n = 5000000+10;
    vector<ll> v(n,1);
    for(i=2;i<n;i++){
        if(v[i]){
            prime.push_back(i);
            for(j=2*i;j<n;j+=i) v[j]=0;
        }
    }
    return;
}

ll gettime(ll d1,ll id1){
    vector<ll> temp;
    ll i;
    for(i=0;prime[i]*prime[i]<=d1;i++){
        if(d1%prime[i]==0){
            temp.push_back(prime[i]);
            while(d1%prime[i]==0) d1/=prime[i];
        }
    }
    if(d1>1) temp.push_back(d1);
    
    ll time = id1;
    i = temp.size()-1;
    while(temp[i]>id1 && i>=0){
        time = temp[i];
        i--;
    }
    return time;
}

bool check(ll base,ll tar){
    ll id1 = bases[base][2];
    ll id2 = target[tar][2];
    
    ll d1 = abs(bases[base][0]-target[tar][0])
            +abs(bases[base][1]-target[tar][1]);
    ll d2 = abs(X-target[tar][0])
            +abs(Y-target[tar][1]);
            
    ll time1 = gettime(d1,id1);
    ll time2 = gettime(d2,id2);
    
    if(time1+time2<=T) return true;
    else return false;
    
}

void addedge(ll u,ll v){
    graph[u].push_back(v);
    return;
}

bool bfs(ll n){
    ll u,v,i,j;
    queue<ll> q;
    for(u=1;u<=n;u++){
        if(matchL[u]==0){
            dist[u]=0;
            q.push(u);
        }
        else dist[u]=inf;
    }
    dist[0]=inf;
    
    while(!q.empty()){
        u = q.front();
        q.pop();
        //cout<<u<<endl;
        if(dist[u]<dist[0]){
            for(i=0;i<graph[u].size();i++){
                v = graph[u][i];
                if(dist[matchR[v]]==inf){
                    dist[matchR[v]]=dist[u]+1;
                    q.push(matchR[v]);
                }
            }
        }
    }
    return dist[0]!=inf;
    
}

bool dfs(ll source){
    if(source==0) return true;
    
    ll i;
    for(i=0;i<graph[source].size();i++){
        ll v = graph[source][i];
        if(dist[matchR[v]]==dist[source]+1 && dfs(matchR[v])){
            matchL[source]=v;
            matchR[v]=source;
            return true;
        }
    }
    dist[source]=inf;
    return false;
}

ll findmatching(ll n){
    matchR.assign(M,0);
    matchL.assign(M,0);

    ll u,v,i;
    ll ans = 0;
    while(bfs(n)){
        //cout<<"bfs yes"<<endl;
        for(u=1;u<=n;u++){
            if(matchL[u]==0 && dfs(u)) ans+=1;
        }
    }
    return ans;
}

int main(){
    pre();

    ll n,m;cin>>n>>m>>T;
    ll i,j,ii,jj;
    
    for(i=0;i<n;i++){
        ll x,y,id;
        cin>>x>>y>>id;
        bases[i][0]=x;
        bases[i][1]=y;
        bases[i][2]=id;
    }
    for(i=0;i<m;i++){
        ll x,y,id;
        cin>>x>>y>>id;
        target[i][0]=x;
        target[i][1]=y;
        target[i][2]=id;
    }
    cin>>X>>Y;
    
    for(i=0;i<n;i++){
        for(j=0;j<m;j++){
            if(check(i,j)){
                addedge(i+1,j+1);
                //cout<<i+1<<" can attack at "<<j+1<<endl;
            }
        }
    }
    //cout<<"now finding match"<<endl;
    ll ans = findmatching(n);
    cout<<ans<<endl;
    
}
