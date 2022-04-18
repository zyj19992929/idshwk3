global relationship : table[addr] of set[string] = table();
event http_all_headers (c: connection, is_orig: bool, hlist:mime_header_list)
{
if(c$http?$user_agent)
{
local sourceIP=c$id$orig_h;
local agent=to_lower(c$http$user_agent);
if(sourceIP in relationship)
{
add (relationship[sourceIP])[agent];
}
else
{
relationship[sourceIP]=set(agent);
}
}
}

event zeek_done() 
{
local temp = 0;
for (ip in relationship) 
{
if (|relationship[ip]| > 2)
{
print fmt("%s is a proxy", ip);
temp = 1;
}
}
if(temp == 0)
{
print "no proxy";
}
}
