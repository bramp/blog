---
title: LaTeX QR Based Business Card
slug: latex-qr-based-business-card
author: bramp
layout: post
date: 2010-02-13
categories:
  - Blog
tags:
  - business card
  - LaTeX
  - QR code
aliases:
  - /blog/2010/02/13/latex-qr-based-business-card/
---
I recently found [this blog][1] which shows a business card with a QR card. I thought I&#8217;d create a business card with LaTeX with a similar QR code. I took a LaTeX template from [here][2], found out about the [pst-barcode pacakge][3], learnt the [MECARD format][4], and combined them to make this:

<!-- TODO link to card-1.pdf -->
{{< figure src="card-1.png" title="My QR Business Card" width="756" height="496" >}}


I doubt I&#8217;ll print this card, but just in case you want to make a similar one, here is the LaTeX source:

```latex
\documentclass[11pt,a4paper]{memoir}

\setstocksize{55mm}{85mm} % UK Stock size
\setpagecc{55mm}{85mm}{*}
\settypeblocksize{45mm}{75mm}{*}
\setulmargins{5mm}{*}{*}
\setlrmargins{5mm}{*}{*}

\setheadfoot{0.1pt}{0.1pt}
\setheaderspaces{1pt}{*}{*}
\checkandfixthelayout[fixed]

\pagestyle{empty}

\usepackage{pstricks}
\usepackage{pst-barcode}

\begin{document}
    %\pagecolor[cmyk]{.22,.36,.51,.08}%
    \begin{Spacing}{0.75}%
    \noindent
    \textbf{Andrew~Brampton~Ph.D.}\\
    \rule{75mm}{1mm}\\
    \begin{minipage}[t]{30mm}
        \vspace{-1mm}%
        \begin{pspicture}(30mm,30mm)
            % The MECARD format is used to exchange contact information. More information at:
            % http://www.nttdocomo.co.jp/english/service/imode/make/content/barcode/function/application/addressbook/index.html
            \psbarcode{MECARD:N:Brampton,Andrew;EMAIL:a.bramptonATlancs.ac.uk;URL:http://bramp.net;;}{eclevel=L width=1.181 height=1.181}{qrcode}
        \end{pspicture}
    \end{minipage}
    \hspace{1mm}
    \begin{minipage}[t]{42mm}
        \vspace{-1mm}%
        \begin{flushright}
        {\scriptsize
            \begin{Spacing}{1.5}%
%           \textbf{Research Associate}\\
            \textbf{Network Researcher}\\
            Computing Department\\
            Lancaster University\vspace{9mm}\\
            \end{Spacing}
        }
        {\tiny
            \textbf{email:} a.brampton AT lancs.ac.uk\\
            \textbf{web:} http://bramp.net/\\
            \vspace*{2mm}
        }
        \end{flushright}
    \end{minipage}
    \rule{75mm}{1mm}
    \end{Spacing}
\end{document}
```

 [1]: http://forthescience.org/blog/2010/02/02/my-business-card-with-qr-code-geeky/
 [2]: http://blog.widmann.org.uk/2009/05/27/1297/
 [3]: http://www.tug.org/texmf-dist/doc/generic/pst-barcode/pst-barcode-doc.pdf
 [4]: https://www.nttdocomo.co.jp/english/service/developer/make/content/barcode/function/application/addressbook/
