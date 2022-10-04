// Copyright (c) 2022 WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

# Client configuration details.
# + auth - Configurations related to client authentication
# + httpVersion - The HTTP version understood by the client
# + http1Settings - Configurations related to HTTP/1.x protocol
# + http2Settings - Configurations related to HTTP/2 protocol
# + timeout - The maximum time to wait (in seconds) for a response before closing the connection
# + forwarded - The choice of setting `forwarded`/`x-forwarded` header
# + poolConfig - Configurations associated with request pooling
# + cache - Specifies the way of handling compression (`accept-encoding`) header
# + compression - Specifies the way of handling compression (`accept-encoding`) header
# + circuitBreaker - Configurations associated with the behaviour of the Circuit Breaker
# + retryConfig - Configurations associated with retrying
# + responseLimits - Configurations associated with inbound response size limits
# + secureSocket - SSL/TLS-related options
# + proxy - Proxy server related options
# + validation - Enables the inbound payload validation functionalty which provided by the constraint package. 
# Enabled by default
public type ConnectionConfig record {|
    AuthConfig auth?;
    http:HttpVersion httpVersion = http:HTTP_2_0;
    ClientHttp1Settings http1Settings?;
    http:ClientHttp2Settings http2Settings?;
    decimal timeout = 60;
    string forwarded = "disable";
    http:PoolConfiguration poolConfig?;
    http:CacheConfig cache?;
    http:Compression compression = http:COMPRESSION_AUTO;
    http:CircuitBreakerConfig circuitBreaker?;
    http:RetryConfig retryConfig?;
    http:ResponseLimitConfigs responseLimits?;
    http:ClientSecureSocket secureSocket?;
    http:ProxyConfig proxy?;
    boolean validation = true;
|};

# Defines the authentication configurations.
public type AuthConfig http:CredentialsConfig|http:BearerTokenConfig|http:JwtIssuerConfig|
OAuth2ClientCredentialsGrantConfig|OAuth2PasswordGrantConfig|OAuth2RefreshTokenGrantConfig|OAuth2JwtBearerGrantConfig;

# Represents OAuth2 refresh token grant configurations for OAuth2 authentication.
#
# + refreshUrl - Refresh token URL of the token endpoint
# + refreshToken - Refresh token for the token endpoint
# + clientId - Client ID of the client authentication
# + clientSecret - Client secret of the client authentication
# + scopes - Scope(s) of the access request
# + defaultTokenExpTime - Expiration time (in seconds) of the tokens if the token endpoint response does not contain an `expires_in` field
# + clockSkew - Clock skew (in seconds) that can be used to avoid token validation failures due to clock synchronization problems
# + optionalParams - Map of the optional parameters used for the token endpoint
# + credentialBearer - Bearer of the authentication credentials, which is sent to the token endpoint
public type OAuth2RefreshTokenGrantConfig record {|
    string refreshUrl;
    @display {
        label: "",
        kind: "password"
    }
    string refreshToken;
    string clientId;
    @display {
        label: "",
        kind: "password"
    }
    string clientSecret;
    string[] scopes?;
    decimal defaultTokenExpTime?;
    decimal clockSkew?;
    map<string> optionalParams?;
    CredentialBearer credentialBearer?;
|};

# Represents the data structure, which is used to configure the OAuth2 client credentials grant type.
#
# + tokenUrl - Token URL of the token endpoint
# + clientId - Client ID of the client authentication
# + clientSecret - Client secret of the client authentication
# + scopes - Scope(s) of the access request
# + defaultTokenExpTime - Expiration time (in seconds) of the tokens if the token endpoint response does not contain an `expires_in` field
# + clockSkew - Clock skew (in seconds) that can be used to avoid token validation failures due to clock synchronization problems
# + optionalParams - Map of the optional parameters used for the token endpoint
# + credentialBearer - Bearer of the authentication credentials, which is sent to the token endpoint
public type OAuth2ClientCredentialsGrantConfig record {|
    string tokenUrl;
    string clientId;
    @display {
        label: "",
        kind: "password"
    }
    string clientSecret;
    string[] scopes?;
    decimal defaultTokenExpTime?;
    decimal clockSkew?;
    map<string> optionalParams?;
    CredentialBearer credentialBearer?;
|};

# Represents the data structure, which is used to configure the OAuth2 password grant type.
#
# + tokenUrl - Token URL of the token endpoint
# + username - Username for the password grant type
# + password - Password for the password grant type
# + clientId - Client ID of the client authentication
# + clientSecret - Client secret of the client authentication
# + scopes - Scope(s) of the access request
# + refreshConfig - Configurations for refreshing the access token
# + defaultTokenExpTime - Expiration time (in seconds) of the tokens if the token endpoint response does not contain an `expires_in` field
# + clockSkew - Clock skew (in seconds) that can be used to avoid token validation failures due to clock synchronization problems
# + optionalParams - Map of the optional parameters used for the token endpoint
# + credentialBearer - Bearer of the authentication credentials, which is sent to the token endpoint
public type OAuth2PasswordGrantConfig record {|
    string tokenUrl;
    string username;
    @display {
        label: "",
        kind: "password"
    }
    string password;
    string clientId?;
    @display {
        label: "",
        kind: "password"
    }
    string clientSecret?;
    string[] scopes?;
    record {|
        string refreshUrl;
        string[] scopes?;
        map<string> optionalParams?;
        CredentialBearer credentialBearer?;
    |} refreshConfig?;
    decimal defaultTokenExpTime?;
    decimal clockSkew?;
    map<string> optionalParams?;
    CredentialBearer credentialBearer?;
|};

# Represents the data structure, which is used to configure the OAuth2 JWT bearer grant type.
#
# + tokenUrl - Token URL of the token endpoint
# + assertion - A single JWT for the JWT bearer grant type
# + clientId - Client ID of the client authentication
# + clientSecret - Client secret of the client authentication
# + scopes - Scope(s) of the access request
# + defaultTokenExpTime - Expiration time (in seconds) of the tokens if the token endpoint response does not contain an `expires_in` field
# + clockSkew - Clock skew (in seconds) that can be used to avoid token validation failures due to clock synchronization problems
# + optionalParams - Map of the optional parameters used for the token endpoint
# + credentialBearer - Bearer of the authentication credentials, which is sent to the token endpoint
public type OAuth2JwtBearerGrantConfig record {|
    string tokenUrl;
    string assertion;
    string clientId?;
    @display {
        label: "",
        kind: "password"
    }
    string clientSecret?;
    string[] scopes?;
    decimal defaultTokenExpTime?;
    decimal clockSkew?;
    map<string> optionalParams?;
    CredentialBearer credentialBearer?;
|};

# Represents the credential-bearing methods.
public enum CredentialBearer {
    AUTH_HEADER_BEARER,
    POST_BODY_BEARER
}

# Provides settings related to HTTP/1.x protocol.
#
# + keepAlive - Specifies whether to reuse a connection for multiple requests
# + chunking - The chunking behaviour of the request
# + proxy - Proxy server related options
public type ClientHttp1Settings record {|
    KeepAlive keepAlive = KEEPALIVE_AUTO;
    Chunking chunking = CHUNKING_AUTO;
    ProxyConfig proxy?;
|};

# Defines the possible values for the keep-alive configuration in service and client endpoints.
public type KeepAlive KEEPALIVE_AUTO|KEEPALIVE_ALWAYS|KEEPALIVE_NEVER;

# Defines the possible values for the chunking configuration in HTTP services and clients.
#
# `AUTO`: If the payload is less than 8KB, content-length header is set in the outbound request/response,
# otherwise chunking header is set in the outbound request/response
# `ALWAYS`: Always set chunking header in the response
# `NEVER`: Never set the chunking header even if the payload is larger than 8KB in the outbound request/response
public type Chunking CHUNKING_AUTO|CHUNKING_ALWAYS|CHUNKING_NEVER;

# Proxy server configurations to be used with the HTTP client endpoint.
#
# + host - Host name of the proxy server
# + port - Proxy server port
# + userName - Proxy server username
# + password - proxy server password
public type ProxyConfig record {|
    string host = "";
    int port = 0;
    string userName = "";
    @display {
        label: "",
        kind: "password"
    }
    string password = "";
|};

# Decides to keep the connection alive or not based on the `connection` header of the client request }
public const KEEPALIVE_AUTO = "AUTO";
# Keeps the connection alive irrespective of the `connection` header value }
public const KEEPALIVE_ALWAYS = "ALWAYS";
# Closes the connection irrespective of the `connection` header value }
public const KEEPALIVE_NEVER = "NEVER";

# If the payload is less than 8KB, content-length header is set in the outbound request/response,
# otherwise chunking header is set in the outbound request/response.}
public const CHUNKING_AUTO = "AUTO";
# Always set chunking header in the response.
public const CHUNKING_ALWAYS = "ALWAYS";
# Never set the chunking header even if the payload is larger than 8KB in the outbound request/response.
public const CHUNKING_NEVER = "NEVER";
