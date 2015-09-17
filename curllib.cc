/* -*- indent-tabs-mode: nil; c-basic-offset: 2; tab-width: 2 -*- */

/* This code is PUBLIC DOMAIN, and is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND. See the accompanying
 * LICENSE file.
 */

#include <nan.h>
#include <curl/curl.h>
#include <string>
#include <vector>

using std::string;
using std::vector;

using Nan::CopyBuffer;
using Nan::Get;
using Nan::GetFunction;
using Nan::NanErrnoException;
using Nan::New;
using Nan::Set;
using Nan::ThrowError;
using Nan::Utf8String;

using v8::Array;
using v8::FunctionTemplate;
using v8::Local;
using v8::Object;
using v8::String;
using v8::Value;

#define LOCAL_STRING_HANDLE(text) \
  New<String>(text).ToLocalChecked()

#define GET_STRING_PROP(obj, key) \
  Get(obj, LOCAL_STRING_HANDLE(key)).ToLocalChecked()->ToString()

#define GET_INT_PROP(obj, key) \
  Get(obj, LOCAL_STRING_HANDLE(key)).ToLocalChecked()->IntegerValue()

size_t appendToBuffer(void *ptr, size_t size,
                      size_t nmemb, void *userdata) {
  string *buffer = static_cast<string *>(userdata);
  buffer->append(static_cast<char *>(ptr), size * nmemb);
  return size * nmemb;
}

size_t pushHeader(void *ptr, size_t size, size_t nmemb, void *userdata) {
  string header(static_cast<char *>(ptr), size * nmemb);
  vector<string> *headers = static_cast<vector<string> *>(userdata);
  headers->push_back(header);
  return size * nmemb;
}

NAN_METHOD(RunCurl) {
  Local<Object> options = Local<Object>::Cast(info[0]);

  Utf8String method(GET_STRING_PROP(options, "method"));
  Utf8String url(GET_STRING_PROP(options, "url"));
  Utf8String body(GET_STRING_PROP(options, "body"));
  long connectTimeout = GET_INT_PROP(options, "connectTimeout");
  long timeout = GET_INT_PROP(options, "timeout");

  Local<Array> reqHeaders =
    Local<Array>::Cast(Get(options, LOCAL_STRING_HANDLE("headers")).ToLocalChecked());

  CURLcode res = CURLE_FAILED_INIT;
  CURL *curl = curl_easy_init();
  if (!curl) {
    return ThrowError("Failed to init curl");
  }

  curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, *method);
  curl_easy_setopt(curl, CURLOPT_URL, *url);

  if (body.length() > 0) {
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, *body);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, (curl_off_t) body.length());
  }

  curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1);
  curl_easy_setopt(curl, CURLOPT_MAXREDIRS, 5);

  std::string bodyBuffer;
  curl_easy_setopt(curl, CURLOPT_WRITEDATA, &bodyBuffer);
  curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, appendToBuffer);

  std::vector<std::string> headers;
  curl_easy_setopt(curl, CURLOPT_HEADERDATA, &headers);
  curl_easy_setopt(curl, CURLOPT_HEADERFUNCTION, pushHeader);

  curl_easy_setopt(curl, CURLOPT_CONNECTTIMEOUT_MS, connectTimeout);
  curl_easy_setopt(curl, CURLOPT_TIMEOUT_MS, timeout);

  struct curl_slist *slist = NULL;
  size_t reqHeaderCount = reqHeaders->Length();
  for (size_t i = 0; i < reqHeaderCount; ++i) {
    slist = curl_slist_append(slist, *Utf8String(Get(reqHeaders, i).ToLocalChecked()));
  }
  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, slist);

  res = curl_easy_perform(curl);

  curl_slist_free_all(slist);

  curl_easy_cleanup(curl);

  Local<Object> result = New<Object>();
  info.GetReturnValue().Set(result);

  if (res == CURLE_OPERATION_TIMEDOUT) {
    Local<String> etimedout = LOCAL_STRING_HANDLE("ETIMEDOUT");
    Local<Value> err = Nan::Error(etimedout);
    Set(Local<Object>::Cast(err), LOCAL_STRING_HANDLE("code"), etimedout);
    return ThrowError(err);
  } else if (res) {
    return ThrowError(curl_easy_strerror(res));
  }

  Set(result, LOCAL_STRING_HANDLE("body"),
    CopyBuffer(bodyBuffer.c_str(), bodyBuffer.size()).ToLocalChecked());

  Local<Array> responseHeaders = New<Array>();
  for (size_t i = 0; i < headers.size(); ++i) {
    Set(responseHeaders, i, New<String>(headers[i].c_str()).ToLocalChecked());
  }
  Set(result, LOCAL_STRING_HANDLE("headers"), responseHeaders);
}

NAN_MODULE_INIT(InitAll) {
  Set(target, New<String>("curl").ToLocalChecked(),
    GetFunction(New<FunctionTemplate>(RunCurl)).ToLocalChecked());
}
NODE_MODULE(curllib, InitAll)
