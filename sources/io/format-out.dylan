Module:       io-internals
Synopsis:     The format out library
Author:       Jonathan Bachrach
Copyright:    Original Code is Copyright (c) 1995-2004 Functional Objects, Inc.
              All rights reserved.
License:      See License.txt in this distribution for details.
Warranty:     Distributed WITHOUT WARRANTY OF ANY KIND

define method format-out (format-string :: <string>, #rest args) => ()
  with-stream-locked (*standard-output*)
    apply(format, *standard-output*, format-string, args);
  end;
end method;

define method force-out () => ()
  with-stream-locked (*standard-output*)
    force-output(*standard-output*);
  end;
end method;

define method format-err (format-string :: <string>, #rest args) => ()
  with-stream-locked (*standard-error*)
    apply(format, *standard-error*, format-string, args);
  end;
end method;

define method force-err () => ()
  with-stream-locked (*standard-error*)
    force-output(*standard-error*);
  end;
end method;
