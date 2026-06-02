import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "CropStress Insight",
  description: "Day 1 crop stress scouting dashboard",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
