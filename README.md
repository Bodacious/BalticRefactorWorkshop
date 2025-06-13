# Baltic Ruby Refactoring workshop

Repository for a workshop that demonstrates parallel refactoring principles using Ruby on Rails.

[![CI](https://github.com/Bodacious/BalticRefactorWorkshop/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/Bodacious/BalticRefactorWorkshop/actions/workflows/ci.yml)

## 📥 Downloading

To clone the repository:

```bash
git clone https://github.com/bodacious/BalticRefactorWorkshop.git
cd BalticRefactorWorkshop
```

## ⚙️ Setup

Install dependencies and prepare the environment:

```bash
bin/setup
```

## 🧪 Running the Test Suite

To execute the full test suite (only system tests for now):

```bash
bundle exec rails test:system
```

## 🚀 Running the Main Application Server

To start the Rails server with development tools:

```bash
bin/dev
```

## 🔌 Running the Third-Party Service

A third-party mock service is included and can be started separately on port 9292:

(We'll provide context for this in the workhshop)

```bash
bin/third-party-service
```
