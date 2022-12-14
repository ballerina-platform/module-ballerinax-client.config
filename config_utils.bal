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
import ballerina/oauth2;

# Construct `http:ClientConfiguration` from Connection config record of a connector.
#
# + config - Connection config record of connector
# + return - Created `http:ClientConfiguration` record or error
public isolated function constructHTTPClientConfig(ConnectionConfig config) returns http:ClientConfiguration|error {
    http:ClientConfiguration httpClientConfig = {
        httpVersion: config.httpVersion,
        timeout: config.timeout,
        forwarded: config.forwarded,
        poolConfig: config.poolConfig,
        compression: config.compression,
        circuitBreaker: config.circuitBreaker,
        retryConfig: config.retryConfig
    };
    if config.auth is AuthConfig {
        httpClientConfig.auth = check initializeAuth(config.auth);
    }
    if config.http1Settings is ClientHttp1Settings {
        ClientHttp1Settings settings = check config.http1Settings.ensureType(ClientHttp1Settings);
        httpClientConfig.http1Settings = {...settings};
    }
    if config.http2Settings is http:ClientHttp2Settings {
        httpClientConfig.http2Settings = check config.http2Settings.ensureType(http:ClientHttp2Settings);
    }
    if config.cache is http:CacheConfig {
        httpClientConfig.cache = check config.cache.ensureType(http:CacheConfig);
    }
    if config.responseLimits is http:ResponseLimitConfigs {
        httpClientConfig.responseLimits = check config.responseLimits.ensureType(http:ResponseLimitConfigs);
    }
    if config.secureSocket is http:ClientSecureSocket {
        httpClientConfig.secureSocket = check config.secureSocket.ensureType(http:ClientSecureSocket);
    }
    if config.proxy is http:ProxyConfig {
        httpClientConfig.proxy = check config.proxy.ensureType(http:ProxyConfig);
    }
    return httpClientConfig;
}

isolated function initializeAuth(AuthConfig? config) returns http:ClientAuthConfig|error {
    http:ClientAuthConfig auth = {};
    if config is http:CredentialsConfig|http:BearerTokenConfig|http:JwtIssuerConfig {
        auth = config;
    } else if config is OAuth2ClientCredentialsGrantConfig {
        auth = {...config};
    } else if config is OAuth2PasswordGrantConfig {
        OAuth2PasswordGrantConfig tokenConfig = check config.ensureType(OAuth2PasswordGrantConfig);
        auth = {
            tokenUrl: tokenConfig.tokenUrl,
            username: tokenConfig.username,
            password: tokenConfig.password
        };
        if tokenConfig.clientId is string {
            auth["clientId"] = tokenConfig.clientId;
        }
        if tokenConfig.clientSecret is string {
            auth["clientSecret"] = tokenConfig.clientSecret;
        }
        if tokenConfig.scopes is string[] {
            auth["scopes"] = tokenConfig.scopes;
        }
        if tokenConfig.optionalParams is map<string> {
            auth["optionalParams"] = tokenConfig.optionalParams;
        }
        if tokenConfig.defaultTokenExpTime is decimal {
            auth["defaultTokenExpTime"] = tokenConfig.defaultTokenExpTime;
        }
        if tokenConfig.clockSkew is decimal {
            auth["clockSkew"] = tokenConfig.clockSkew;
        }
        if tokenConfig.credentialBearer is CredentialBearer {
            auth["credentialBearer"] = tokenConfig.credentialBearer;
        }
        if tokenConfig.refreshConfig is record {|
            string refreshUrl;
            string[] scopes?;
            map<string> optionalParams?;
            CredentialBearer credentialBearer?;
        |} {
            record {|
                string refreshUrl;
                string[] scopes?;
                map<string> optionalParams?;
                CredentialBearer credentialBearer?;
            |}? refreshConfig = tokenConfig.refreshConfig;
            record {|
                string refreshUrl;
                string[] scopes?;
                map<string> optionalParams?;
                oauth2:CredentialBearer credentialBearer;
                oauth2:ClientConfiguration clientConfig = {};
            |} httpRefreshConfig = {
                refreshUrl: <string>refreshConfig["refreshUrl"],
                credentialBearer: <oauth2:CredentialBearer>refreshConfig["credentialBearer"]
            };
            if refreshConfig["scopes"] is string[] {
                auth["scopes"] = tokenConfig.scopes;
            }
            if refreshConfig["optionalParams"] is map<string> {
                auth["optionalParams"] = tokenConfig.optionalParams;
            }
            if tokenConfig.credentialBearer is CredentialBearer {
                auth["credentialBearer"] = tokenConfig.credentialBearer;
            }
            auth["refreshConfig"] = httpRefreshConfig;
        }
    } else if config is OAuth2RefreshTokenGrantConfig {
        auth = {...config};
    } else if config is OAuth2JwtBearerGrantConfig {
        auth = {...config};
    }
    return auth;
}
