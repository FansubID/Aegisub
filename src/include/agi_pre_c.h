// Copyright (c) 2006, Rodrigo Braz Monteiro
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//   * Redistributions of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//   * Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//   * Neither the name of the Aegisub Group nor the names of its contributors
//     may be used to endorse or promote products derived from this software
//     without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
// Aegisub Project http://www.aegisub.org/

#include "../../acconf.h"

#define WIN32_LEAN_AND_MEAN

#ifdef _WIN32
#include <objbase.h>
#include <mmsystem.h>
#else
#include <sys/param.h>
#endif

// wxWidgets headers
#include <wx/defs.h> // Leave this first.

#include <wx/accel.h>
#include <wx/app.h>
#include <wx/arrstr.h>
#include <wx/bitmap.h>
#include <wx/bmpbuttn.h>
#include <wx/brush.h>
#include <wx/button.h>
#include <wx/checkbox.h>
#include <wx/checklst.h>
#include <wx/choicdlg.h>
#include <wx/choice.h>
#include <wx/clipbrd.h>
#include <wx/colour.h>
#include <wx/combobox.h>
#include <wx/containr.h>
#include <wx/control.h>
#include <wx/ctrlsub.h>
#include <wx/cursor.h>
#include <wx/dataobj.h>
#include <wx/dc.h>
#include <wx/dcbuffer.h>
#include <wx/dcclient.h>
#include <wx/dcmemory.h>
#include <wx/dcprint.h>
#include <wx/dialog.h>
#include <wx/dirdlg.h>
#include <wx/dnd.h>
#include <wx/dynarray.h>
#include <wx/event.h>
#include <wx/file.h>
#include <wx/filedlg.h>
#include <wx/filefn.h>
#include <wx/filename.h>
#include <wx/font.h>
#include <wx/frame.h>
#include <wx/gdicmn.h>
#include <wx/gdiobj.h>
#include <wx/glcanvas.h>
#include <wx/hash.h>
#include <wx/hashmap.h>
#include <wx/icon.h>
#include <wx/image.h>
#include <wx/intl.h>
#include <wx/layout.h>
#include <wx/list.h>
#include <wx/listbox.h>
#include <wx/listctrl.h>
#include <wx/log.h>
#include <wx/math.h>
#include <wx/memory.h>
#include <wx/menu.h>
#include <wx/menuitem.h>
#include <wx/module.h>
#include <wx/msgdlg.h>
#include <wx/object.h>
#include <wx/palette.h>
#include <wx/panel.h>
#include <wx/pen.h>
#include <wx/power.h>
#include <wx/radiobox.h>
#include <wx/radiobut.h>
#include <wx/region.h>
#include <wx/sashwin.h>
#include <wx/scrolwin.h>
#include <wx/settings.h>
#include <wx/sizer.h>
#include <wx/spinctrl.h>
#include <wx/statbox.h>
#include <wx/statline.h>
#include <wx/stattext.h>
#include <wx/statusbr.h>
#include <wx/stc/stc.h>
#include <wx/stopwatch.h>
#include <wx/strconv.h>
#include <wx/stream.h>
#include <wx/string.h>
#include <wx/textctrl.h>
#include <wx/thread.h>
#include <wx/timer.h>
#include <wx/toolbar.h>
#include <wx/toplevel.h>
#include <wx/utils.h>
#include <wx/valgen.h>
#include <wx/validate.h>
#include <wx/valtext.h>
#include <wx/window.h>
#include <wx/wxcrt.h>
#include <wx/wxcrtvararg.h>

#ifdef HAVE_OPENGL_GL_H
#include <OpenGL/gl.h>
#else
#include <GL/gl.h>
#endif

